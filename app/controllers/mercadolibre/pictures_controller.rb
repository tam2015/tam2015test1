class Mercadolibre::PicturesController < ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
  # load_and_authorize_resource class: Mercadolibre::Item

  protect_from_forgery except: :upload


  respond_to :html, :json, :js

  # DashboardsHelper callback
  before_action :set_dashboard, except: [ :restory ]

  def index
    @pictures = Mercadolibre::Picture.where(item_id: params[:id])
    @picture = Mercadolibre::Picture.new
  end

  def new
    @picture = Mercadolibre::Picture.new
  end

  def create
    @picture = Mercadolibre::Picture.new(picture_params)
    @picture.item_id = params[:id]
    if @picture.save
      a = "http://www.aircrm.com.br"
      b = @picture.cwave.url
      c = a + b
      @picture.update(source: c)
      redirect_to dashboard_pictures_path
    end
  end

  private


    def picture_params
      params.require(:mercadolibre_picture).permit(
        :cwave,
        :item_id
                )
    end
end
