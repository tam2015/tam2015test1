class Mercadolibre::ItemsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  # load_and_authorize_resource class: Mercadolibre::Item

  protect_from_forgery except: :upload


  respond_to :html, :json, :js

  before_action :set_klass
  # DashboardsHelper callback
  before_action :set_dashboard, except: [ :restory ]
  before_action :set_item, only: [ :show, :edit, :update, :destroy]#, :restore, :upload, :pictures ]


  # Breadcrumbs
  # /dashboard/items
  before_action do
    add_breadcrumb (@dashboard.name || :index ), dashboard_path(@dashboard)
    add_breadcrumb :index, :dashboard_items_path
  end

  # /item
  before_action only: [ :show, :edit ] do
    add_breadcrumb (@item.title || @item.id.to_s ), dashboard_item_path(@dashboard, @item)
  end

  # ON COLLECTION

  # GET /items
  def index
    unless @dashboard.nil?
      @items =
        if params[:deleted]
          add_breadcrumb :trash

          @klass.where(dashboard_id: @dashboard.id).includes(:pictures).deleted
        else
          add_breadcrumb :all

          @klass.where(dashboard_id: @dashboard.id).includes(:pictures).all
        end
    end
  end

  def refresh
    Mercadolibre::Workers::ItemWorker.perform_async @dashboard.meli_user_id

    if request.format.html?
      redirect_to dashboard_items_path @dashboard
    else
      @items = @klass.where(dashboard_id: @dashboard.id).all
    end
  end

  # ON MEMBER

  # GET /items/1
  def show
  end

  # GET /items/new
  def new
    @item = Mercadolibre::Item.empty.where(dashboard_id: @dashboard.id).first_or_initialize do |item|
      item.user_id      = current_user.id    if current_user
      item.account_id   = current_account.id if current_account
      item.save
    end

    if @item.created_at? and !request.xhr?
      redirect_to edit_dashboard_item_path @dashboard, @item
    end
  end

  # GET /items/1/edit
  def edit
    if @item.empty?
      add_breadcrumb :new
    else
      add_breadcrumb :edit
    end
  end

  # POST /items
  def create
    @item = Mercadolibre::Item.new(item_params)
    @item.dashboard_id = @dashboard.id      if @dashboard
    @item.user_id      = current_user.id    if current_user
    @item.account_id   = current_account.id if current_account

    if @item.save
      flash[:success] = "Item was successfully updated."
      location= dashboard_item_path(@dashboard, @item)
    else
      location= edit_dashboard_item_path(@dashboard, @item)
    end

    respond_with @item, location: location
  end

  # PATCH/PUT /items/1
  def update
    puts "\n\n\n\n"

    # Use update ':attributes' and ':save' instead of ':update'
    puts " => params = #{item_params.to_h.to_json}"
    puts "\n\n"

    @item.attributes= item_params.to_h

    puts " ===> changed? = #{@item.changed?}"
    puts " => changes: #{@item.changes.to_json}"
    puts "\n\n"
    puts " => variations: #{item_params[:variations].to_json}"
    puts "\n\n\n\n"

    # if published update, else valid
    if @item.changed?
      if @item.meli_item_id?
        # Update in meli
        if @item.publish_in_meli!
          flash[:success] = "O Anúncio foi atualizado no Mercado Livre."
          location= dashboard_item_path(@dashboard, @item)
        else
          flash[:alert] = "Não possível atualizar o anúncio no Mercado Livre."
          location= edit_dashboard_item_path(@dashboard, @item)
        end
      else
        # valid and save
        if @item.validate_in_meli!
          if @item.validation_status == :valid
            flash[:success] = "O Anúncio foi atualizado e validado no Mercado Livre."
          else
            flash[:alert] = "O Anúncio foi atualizado porém não é válido para o Mercado Livre."
          end

          location= dashboard_item_path(@dashboard, @item)
        else
          location= edit_dashboard_item_path(@dashboard, @item)
        end
      end
    else
      flash[:success] = "O Anúncio não sofreu alterações."
      location= dashboard_item_path(@dashboard, @item)
    end

    respond_with @item, location: location
  end

  # DELETE /items/1
  def destroy
    if @force = params[:force]
      flash[:error] = "Item was successfully destroyed."
      @item.destroy!
    else
      flash[:alert] = "Item was successfully deleted."
      @item.destroy
    end
    respond_with nil, location: dashboard_items_path(@dashboard)
  end

  # Sync with API
  def restore
    @item.restore
    flash[:success] = "Item was successfully restored."
    respond_with @item
  end

  def publish
    if @item.publish_in_meli
      @item.save
      flash[:success] = "Item was successfully restored."
    else
      @item.errors.each do |error|
        flash[:error] = "<b>Erro #{error}:</b> #{@item.errors.messages[error].join(' ')}"
      end
    end

    redirect_to dashboard_item_path(@dashboard, @item)
  end

  # upload and relation picture
  def upload
    picture = @item.pictures.build
    puts "* PICTURE: #{picture.inspect}"
    picture.image = params[:pictures]

    if params[:variation_index] and picture
      variation_index = params[:variation_index].to_i

      @item.variations ||= []
      @item.variations[variation_index] ||= {}
      @item.variations[variation_index][:picture_ids] ||= []
      @item.variations[variation_index][:picture_ids] << picture.id.to_s
    end

    @item.pictures << picture
    @item.save

    location= dashboard_item_path(@dashboard, @item)
    respond_with @item, location: location
  end

  # get all picutres
  def pictures
  end

  # Sync with API
  def sync
    respond_with @item
  end

  def catalog_import
  end

  def import
    if Mercadolibre::Item.import(params[:file], @dashboard)
      redirect_to dashboard_items_path
      flash.alert = "Catálogo atualizado com sucesso"
    else
      #redirect_to como_importar_excel_url
    end
  end

  # def catalogo_franquiador
  #   user_brands = User.user_brands(current_user)
  #   if user_brands
  #     #@items = Mercadolibre::Item.where("f_marca" => { "$in" => ["mor", "bea", "joy"] }).paginate(page: params[:page], per_page: 7) #inserir where(catalog_id: "x",)
  #     @items = Mercadolibre::Item.where(dashboard_id: @dashboard.id).where("f_marca" => { "$in" => user_brands }).paginate(page: params[:page], per_page: 7) #inserir where(catalog_id: "x",)
  #   end
  # end

  def catalogo_franquiador
    if !params[:f_marca]
      @items = Mercadolibre::Item.all.paginate(page: params[:page], per_page: 7) #inserir where(catalog_id: "x",)
    end
    if params[:f_marca]
      @items = Mercadolibre::Item.where(f_marca: params[:f_marca]).all.paginate(page: params[:page], per_page: 7) #inserir where(catalog_id: "x",)
    end
  end

  private

    # Short class
    def set_klass
      @klass = Mercadolibre::Item
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      item_id = params[:id] || params[:meli_item_id]
      @item = @klass.unscoped.find(item_id)
    end

    def item_params
      params.require(:item).permit(
        :title,
        :condition,

        :buying_mode,
        :price, :base_price,
        :listing_type_id,
        :original_price,
        :coverage_areas, :attributes_ajusted, :listing_source,
        :tags, :warranty, :catalog_product_id, :seller_custom_field,
        :differential_pricing, :automatic_relist,

        # Quantities
        :initial_quantity, :available_quantity, :sold_quantity, :quantity_from_store,

        # Shipping
        :location, :geolocation,
        :seller_address, :seller_contact,

        # Status
        :status, :sub_status,

        # Medias
        :thumbnail, :secure_thumbnail, :pictures, :description, :permalink,
        :youtube_url,

        # Dates
        :created_at, :updated_at,
        :start_time, :stop_time, :end_time,

        # associations
        :user_id,
        :dashboard_id,

        # Mercadolibre
        :meli_item_id, # ID in provider
        :meli_user_id, # ID of ML user
        :official_store_id,
        :site_id,
        :category_id,
        :currency_id,
        :parent_item_id,

        # Payment
        :accepts_mercadopago,

        variations: [
          :color_primary_id,
          :color_secundary_id,
          :size_id,
          :available_quantity
        ],
        shipping: [
          :local_pick_up,
          :mode,
          :free_shipping,
          :dimensions,

          costs:      [ :name, :cost ]
        ],
        non_mercado_pago_payment_methods: []
        )
    end
end
