class Mercadolibre::StoragesController < ApplicationController
  require 'will_paginate/array'

  before_action :authenticate_user!
  # load_and_authorize_resource class: Mercadolibre::Item

  respond_to :html, :json, :js

  before_action :set_klass
  # DashboardsHelper callback
  before_action :set_dashboard, except: [ :restory ]
  # before_action :set_item, only: [ :show, :edit, :update, :destroy, :restore ]


  # Breadcrumbs
  # /dashboard/items
  before_action do
    add_breadcrumb (@dashboard.name || :index ), dashboard_path(@dashboard)
    add_breadcrumb :index, :dashboard_items_path
  end

  # /item
  # before_action only: [ :show, :edit ] do
  #   add_breadcrumb (@item.title || @item.id ), dashboard_item_path(@dashboard, @item)
  # end

  # GET /items
  def index
    @storages = Mercadolibre::Storage.all.paginate(page: params[:page], per_page: 7)
  end

  def edit
    @storage = Mercadolibre::Storage.where(f_codigo: params[:f_codigo]).first_or_initialize
  end

  def update
    params = storage_params.merge!({
      dashboard_id: current_dashboard.id,
      user_id: current_user.id
    })

    Rails.logger.debug " \n\n\n\n\n\n\n\n\n-------------------params #{params}"

    @storage = Mercadolibre::Storage.where(f_codigo: params[:f_codigo]).first_or_initialize


    @storage.update(params)

    @update_item_quantity = Mercadolibre::Item.update_item_quantity(@storage.meli_item_id)

    redirect_to  catalog_dashboard_storages_path

  end

  def import
    if Mercadolibre::Storage.import(params[:file])
      redirect_to dashboard_storages_url
      flash.alert = "Estoque atualizado com sucesso"
    else
      redirect_to dashboard_storages_url
      flash.alert = "Problema na importação do arquivo"
    end
  end

  def catalog_import
  end

  def catalog
    #used to render catalog
    @items = Mercadolibre::Item.all.paginate(page: params[:page], per_page: 7)
    #used to render storages
    @storages = Mercadolibre::Storage.all.paginate(page: params[:page], per_page: 7)
  end

  def stores_per_item #store = user
    @storages = Mercadolibre::Storage.where(f_codigo: params[:f_codigo].to_s)
    @users = []
    @storages.each do |storage|
      user_id = storage.user_id
      Rails.logger.debug " \n\n\n\n\n\n\n\n\n-------------------user_id #{user_id}"
      user = User.where(id: user_id).first
      @users << user
    end
    @storages
    @users
  end

  # def catalog
  #   user_brands = User.user_brands(current_user)
  #   if user_brands
  #     #@items = Mercadolibre::Item.where("f_marca" => { "$in" => ["mor", "bea", "joy"] }).paginate(page: params[:page], per_page: 7) #inserir where(catalog_id: "x",)
  #     @items = Mercadolibre::Item.where(dashboard_id: @dashboard.id).where("f_marca" => { "$in" => user_brands }).paginate(page: params[:page], per_page: 7) #inserir where(catalog_id: "x",)
  #   end
  # end



  private

      # Short class
      def set_klass
        @klass = Mercadolibre::Item
      end

      # Use callbacks to share common setup or constraints between actions.
      # def set_item
      #   item_id = params[:id] || params[:item_id]
      #   @sitem = @klass.unscoped.find(item_id)
      # end

      def storage_params
        params.require(:mercadolibre_storage).permit(:l_quantity, :meli_item_id, :f_codigo, :f_descricao

          # associations
          #:category_id,
          #:user_id, :dashboard_id
          )
      end
  end




