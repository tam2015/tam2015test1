class DashboardsController < ApplicationController
  # Auth
  before_action :authenticate_user!
  load_and_authorize_resource

  respond_to :html, :js, :json

  # DashboardsHelper callback
  before_action :set_dashboard, only: [:show, :edit, :update, :destroy, :questions, :search, :reload]

  #before_filter :trial_period_checked
  #before_filter :check_payment_status

  add_breadcrumb :index, :dashboards_path

  def search
    @boxes = if params[:query]
      @dashboard.boxes.where("name ilike :q or description ilike :q", q: "%#{params[:query]}%")
    else
      @dashboard.boxes
    end

    @boxes_selector = @boxes.collect { |box| box.id }

    # @steps = @dashboard.steps
    respond_with @boxes
  end


  def reload
    # BoxWorker.perform_async(@dashboard.id)

    @steps = @dashboard.steps
    @boxes = @dashboard.boxes

    respond_with @steps
  end

  # GET /dashboards
  # GET /dashboards.json
  def index
    # @dashboards = if current_user.admin?
    #   # Dashboard.all
    #   # FIXME: Estou colocando esse limite pelo motivo de a aplicação cair se deixar todos
    #   # o correto nesse caso é refatorar os contadores de box e ativar paginação.
    #   # Dashboard.limit(30).order("updated_at DESC").all
    #   Dashboard.all.order("boxes_count DESC").order("updated_at DESC").limit(10)#.includes(:boxes)
    # else
    #   current_user.dashboards
    # end
  end

  # GET /dashboards/1
  # GET /dashboards/1.json
  def show
    # Meli
    # @ml_orders = Box.orders_update current_user
    @steps = @dashboard.steps
    @boxes = @dashboard.boxes.includes(:customer)
  end

  # GET /dashboards/new
  def new
    @dashboard = Dashboard.new
  end

  # GET /dashboards/1/edit
  def edit
  end

  # POST /dashboards
  # POST /dashboards.json
  def create
    @dashboard = current_user.dashboards.create(dashboard_params)
    @dashboard.account= current_account

    respond_to do |format|
      if @dashboard.save
        format.html { redirect_to @dashboard, notice: 'Dashboard was successfully created.' }
        format.json { render action: 'show', status: :created, location: @dashboard }
      else
        format.html { render action: 'new' }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dashboards/1
  # PATCH/PUT /dashboards/1.json
  def update
    respond_to do |format|
      if @dashboard.update(dashboard_params)
        format.html { redirect_to dashboards_url, notice: 'Nome atualizado com sucesso' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboards/1
  # DELETE /dashboards/1.json
  def destroy
    @dashboard.destroy
    Step.where(:dashboard_id => @dashboard.id).each { |step| step.destroy }
    Box.where(:dashboard_id => @dashboard.id).each { |box| box.destroy }
    respond_to do |format|
      format.html { redirect_to dashboards_url }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def dashboard_params
      params.require(:dashboard).permit(:name,
        # OAuth
        :provider, :meli_user_id, :token, :secret,
        # Assosiations
        :account_id, :user_id)
    end
end
