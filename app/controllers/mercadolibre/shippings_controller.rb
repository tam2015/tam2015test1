class Mercadolibre::ShippingsController < ApplicationController
  layout "providers/mercadolibre"

  respond_to :html, :json, :js

  before_action :set_shipping , only: [:edit, :update, :notify, :status]
  before_action :set_notify   , only: [:update]


  def edit
  end

  def receiver
    shipping_id = Mercadolibre::Shipping.verify(params[:token])
    @shipping = set_shipping shipping_id

    # fallback beacause reicever_address dont model
    @receiver_address = @shipping.receiver_address || {}
  end

  def update
    @__receiver_page = params[:receiver] || false


    update_params = {}

    if @__receiver_page
      update_params[:status             ] = :pending
      update_params[:shipment_type      ] = :custom_shipping
      update_params[:updated_by_buyer_at] = Time.current
    end

    update_params[:status] = shipping_params[:status] if shipping_params[:status]

    if receiver_address = shipping_params[:receiver_address]
      update_params[:receiver_address] = {}

      [ :id, :latitude, :longitude, :city, :state, :zip_code, :street_name,
        :street_number, :comment, :country, :address_line ].each do |attr_key|

        attr_key = attr_key.to_sym
        if receiver_address.include?(attr_key)
          value = receiver_address[attr_key]

          # change value to hash in :city and :state field
          value = { name: value } if [:city, :state].include?(attr_key)

          update_params[:receiver_address][attr_key] = value

          update_params.merge!(updated_by_seller: true)
        end
      end
      # SIMILAR:
      # if receiver_address.include?(:id)
      #   update_params[:receiver_address][:id] = receiver_address[:id]
      # end
    end

    @notify.updated! if @notify

    if @shipping.update(update_params)
      flash[:success] = 'Shipping was successfully updated.'
      redirect_to dashboard_index_test_path @shipping.dashboard_id
    else
      @shipping.errors.each do |code, message|
        flash[:error] = message
      end
    end

    # respond_with @shipping do |format|
    #   format.js
    # end
  end

  def update_status
    @shipping = Mercadolibre::Shipping.where(box_id: params[:mercadolibre_shipping][:box_id]).first
    box = ::Box.where(id: params[:mercadolibre_shipping][:box_id]).first
    saved = box.update_tags_from_shipping_changes box, @shipping, params
    if saved
      flash[:success] = 'Atualizado com sucesso'
      redirect_to dashboard_index_test_path @shipping.dashboard_id
    else
      redirect_to dashboard_index_test_path @shipping.dashboard_id
      flash[:error] = "O Mercado Envios atualiza o status automaticamente"
    end
  end


  def notify
    notify_param = params[:type]
    @notify = @shipping.notify @shipping.box, notify_param
    if @notify
      flash[:success] = 'Email enviado com sucesso'
      redirect_to dashboard_index_test_path @shipping.dashboard_id
    else
      redirect_to dashboard_index_test_path @shipping.dashboard_id
      flash[:error] = "Não foi possível enviar o email, por favor fale com a nossa equipe"
    end
  end

  def status
    # @shipping = Mercadolibre::Shipping.find(params[:shipping_id])
  end

  # def update_status
  #   @shipping = Mercadolibre::Shipping.find(shipping_params[:mid]).first
  #   Rails.logger.debug "\n\n\n\n\n\n\n\n\n\n\n\n --> params[mid]: #{shipping_params[:mid]} \n\n\n\n\n\n\n\n\n\n\n"
  #   @shipping_updated = @shipping.update(status: shipping_params[:status])
  # end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_notify
      @notify = ::Notify.where( reference_id:@shipping.id.to_s, reference_model: @shipping.model_name.to_s ).first if @shipping
    end

    def set_shipping(shipping_id=nil)
      @shipping = Mercadolibre::Shipping.find(shipping_id || params[:shipping_id] || params[:id])
    end

    def shipping_params
      receiver_address_params = [ :address_line, :street_name, :street_number, :comment, :city, :state, :zip_code, :country ]
      #params.require(:shipping).permit( :receiver_address_s, :status, :updated_by_buyer_at, receiver_address: receiver_address_params )
      params.require(:shipping).permit( :receiver_address_s, :status, :updated_by_buyer_at, receiver_address: receiver_address_params )
    end

end
