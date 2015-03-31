class Mercadolibre::ItemsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  # load_and_authorize_resource class: Mercadolibre::Item

  respond_to :html, :json, :js

  before_action :set_klass
  # DashboardsHelper callback
  before_action :set_dashboard
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
    @items = @klass.where(dashboard_id: @dashboard.id).active.includes(:pictures)

    # respond_with @items
    respond_with(@items) do |format|
      format.csv { send_data @items.to_csv, filename: 'aircrm_anuncios.csv' }
      format.xls { send_data @items.to_xls, filename: 'aircrm_anuncios.xls' }
      # format.xls # { send_data @users.to_csv(col_sep: "\t") }
    end
    if current_user.admin?
      @items = @klass.all.active.includes(:pictures)      
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
      flash[:success] = "Etapa concluída com sucesso."
      redirect_to dashboard_pictures_path(id: @item.id), method: :get
    else
      location= new_dashboard_item_path(@dashboard, @item)
    end
    new_dashboard_item_path(category_id: item_params[:category_id])

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

  def edit
    @item = Mercadolibre::Item.find params[:id]
  end

  def update
    @item = Mercadolibre::Item.find(params[:id])#.edit(item_params)
    @item.category_id       = @item.category_id
    @item.title             = item_params[:title]
    @item.description       = item_params[:description]
    @item.condition         = item_params[:condition]
    @item.buying_mode       = item_params[:buying_mode]
    @item.listing_type_id   = item_params[:listing_type_id]
    @item.price             = item_params[:price]
    @item.warranty          = item_params[:warranty]

    if @item.save
      flash[:success] = "Etapa concluída com sucesso."
      redirect_to dashboard_pictures_path(id: @item.id, goal: "update_item"), method: :get
    else
      location= edit_dashboard_item_path(@dashboard, @item)
    end

    #update item_meli_info
    if item_meli_info = Mercadolibre::MeliInfo.where(item_id: @item.id).first
      item_meli_info.accepts_mercadopago                      = true if params["meli_infos"]["accepts_mercadopago"] == true
      item_meli_info.shipping                                 = {"mode"=>"me2", "local_pick_up"=>true, "free_shipping"=>false, "methods"=>[], "dimensions"=>dimension} if  @dashboard.preferences.shipping_modes.include?("me2") and  params["meli_infos"]["shipping"] == true
      item_meli_info.non_mercado_pago_payment_methods         = [{"id"=>"MLBMO", "description"=>"Dinheiro", "type"=>"G"}, {"id"=>"MLBCC", "description"=>"Cartão de Crédito", "type"=>"N"}, {"id"=>"MLBDE", "description"=>"Depósito Bancário", "type"=>"D"}].to_json #if row["non_mercado_pago_payment_methods"] == "sim" #and item.price < 200
      item_meli_info.site_id                                  = "MLB"
      item_meli_info.currency_id                              = "BRL"
      item_meli_info.save
    end

    #update item_storage
    if item_storage = Mercadolibre::ItemStorage.where(item_id: @item.id).first_or_initialize
      Rails.logger.debug "\n\n\n\n\n\n----------- params#{params[:item][:item_storages][:available_quantity]}\n\n\n\n\n--------"
      item_storage.available_quantity = params[:item][:item_storages][:available_quantity]
      item_storage.save
    end

  end

  def publish
    item = Mercadolibre::Item.find params[:id]
    published_item = item.publish_in_meli @dashboard
    if item.meli_item_id #check if meli_response has a meli_item_id
      flash[:success] = "Anúncio publicado com sucesso."
      redirect_to dashboard_items_path, method: :get
    else
      flash[:error] = "Não foi possível publicar o seu anúncio. Faça seu logout, faça o login e tente novamente"
      redirect_to dashboard_items_path, method: :get
    end
  end

  def meli_update
    item = Mercadolibre::Item.find params[:id]
    published_item = item.update_in_meli @dashboard
    if item.meli_item_id #check if meli_response has a meli_item_id
      flash[:success] = "Anúncio editado com sucesso."
      redirect_to dashboard_items_path, method: :get
    else
      flash[:error] = "Não foi possível publicar o seu anúncio. Faça seu logout, faça o login e tente novamente"
      redirect_to dashboard_items_path, method: :get
    end
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
