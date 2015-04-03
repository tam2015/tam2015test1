class CustomersController < ApplicationController

  respond_to :html, :json, :js


  before_action :set_customer, only: [:show, :edit, :update, :destroy]


  # GET /customers
  # GET /customers.json
  def index
    if params[:query]
      @customers = current_user.customers.where("email ilike :q or nickname ilike :q", q: "%#{params[:query]}%").paginate(page: params[:page], per_page: 5)
    elsif params[:status_question_customer]
      @customers = current_user.customers.where(blocked: params[:status_question_customer]).paginate(page: params[:page], per_page: 5)
    elsif params[:status_order_customer]
      @customers = current_user.customers.where(blocked: params[:status_order_customer]).paginate(page: params[:page], per_page: 5)
    else
      @customers = current_user.customers.paginate(page: params[:page], per_page: 5)
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    flash[:notice] = 'Customer was successfully created.' if @customer.save
    respond_with @customer
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    if @customer.update(customer_params)
        @customer.update_pendings
      flash[:notice] = 'Customer was successfully updated.'
      respond_with @customer
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    # Remove comments to use Paranoia
    # if @force = params[:force]
      flash[:error] = "Customer was successfully destroyed."
      @customer.destroy!
    # else
    #   flash[:alert] = "Customer was successfully deleted."
    #   @customer.destroy
    # end

    respond_with @customer
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_customer(customer_id=nil)
      @customer = Customer.find(customer_id || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :phone, :email,
        # Assosiations
        :user_id, :account_id)
    end
end
