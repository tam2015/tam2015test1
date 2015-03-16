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


  # GET /items/1
  def show
  end


  def new
    @item = Mercadolibre::Item.new
  end


  # POST /items
  def create
    @item = Mercadolibre::Item.new(item_params)
    @item.dashboard_id = @dashboard.id      if @dashboard
    @item.account_id   = current_account.id if current_account
    @item.status       = :unpublished

    if @item.save
      flash[:success] = "Item was successfully updated."
      redirect_to dashboard_pictures_path(id: @item.id), method: :get
    else
      location= edit_dashboard_item_path(@dashboard, @item)
    end

    #create item_meli_info
    item_meli_info = Mercadolibre::MeliInfo.where(item_id: @item.id).first_or_initialize
    item_meli_info.accepts_mercadopago                      = true if params["meli_infos"]["accepts_mercadopago"] == true
    item_meli_info.shipping                                 = {"mode"=>"me2", "local_pick_up"=>true, "free_shipping"=>false, "methods"=>[], "dimensions"=>dimension} if  @dashboard.preferences.shipping_modes.include?("me2") and  params["meli_infos"]["shipping"] == true
    item_meli_info.non_mercado_pago_payment_methods         = [{"id"=>"MLBMO", "description"=>"Dinheiro", "type"=>"G"}, {"id"=>"MLBCC", "description"=>"Cartão de Crédito", "type"=>"N"}, {"id"=>"MLBDE", "description"=>"Depósito Bancário", "type"=>"D"}].to_json #if row["non_mercado_pago_payment_methods"] == "sim" #and item.price < 200
    item_meli_info.site_id                                  = "MLB"
    item_meli_info.currency_id                              = "BRL"
    item_meli_info.save

    #create item_storage
    item_storage = Mercadolibre::ItemStorage.where(item_id: @item.id).first_or_initialize
    Rails.logger.debug "\n\n\n\n\n\n----------- params#{params[:item][:item_storages][:available_quantity]}\n\n\n\n\n--------"
    item_storage.available_quantity = params[:item][:item_storages][:available_quantity]
    item_storage.save
  end

  def publish
    item = Mercadolibre::Item.find params[:id]
    item.publish_in_meli @dashboard
  end

  def import
    if Mercadolibre::Item.import(params[:file], @dashboard)
      redirect_to dashboard_items_path
      flash.alert = "Catálogo atualizado com sucesso"
    else
      #redirect_to como_importar_excel_url
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
        :warranty,

        :buying_mode,
        :price,
        :listing_type_id,
        :category_id,

        # Status
        :status,

        # Medias
        :thumbnail, :secure_thumbnail, :pictures, :description, :permalink,
        :youtube_url,

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

        variations: [
          :color_primary_id,
          :color_secundary_id,
          :size_id,
          :available_quantity
        ]
        )
    end
end
