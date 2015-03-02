class HistoricalsController < ApplicationController
  before_action :set_historical, only: [:show, :edit, :update, :destroy]

  # GET /historicals
  # GET /historicals.json
  def index
    @historicals = current_user.historicals
  end

  # GET /historicals/1
  # GET /historicals/1.json
  def show
  end

  # GET /historicals/new
  def new
    @historical = Historical.new
  end

  # GET /historicals/1/edit
  def edit
  end

  # POST /historicals
  # POST /historicals.json
  def create
    @historical = current_user.historicals.new(historical_params)

    respond_to do |format|
      if @historical.save
        format.html { redirect_to @historical, notice: 'Historical was successfully created.' }
        format.json { render action: 'show', status: :created, location: @historical }
      else
        format.html { render action: 'new' }
        format.json { render json: @historical.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /historicals/1
  # PATCH/PUT /historicals/1.json
  def update
    respond_to do |format|
      if @historical.update(historical_params)
        format.html { redirect_to @historical, notice: 'Historical was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @historical.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /historicals/1
  # DELETE /historicals/1.json
  def destroy
    @historical.destroy
    respond_to do |format|
      format.html { redirect_to historicals_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_historical
      @historical = Historical.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def historical_params
      params.require(:historical).permit(:user_name, :deal_name, :comment_content, :step_name, :step_id, :customer_name)
    end
end
