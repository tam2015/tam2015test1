class Mercadolibre::PaymentsController < ApplicationController

  #before_action :set_dashboard , only: [:edit, :update]

  def edit
    @payment = Mercadolibre::Payment.where(id: params[:id]).first
  end

  def update
    @payment = Mercadolibre::Payment.where(box_id: params[:mercadolibre_payment][:box_id]).first
    box = ::Box.where(id: params[:mercadolibre_payment][:box_id]).first
    if box.update_tags_from_payment_changes box, @payment, params
      redirect_to dashboard_index_test_path box.dashboard_id
      flash[:success] = "Atualizado com sucesso"
    else
      flash[:error] = "O Mercado Pago atualiza o status do pagamento automaticamente"
      redirect_to dashboard_index_test_path box.dashboard_id
    end
  end

  private

  def payment_params
    params.require(:mercadolibre_payments).permit(:status )
  end



end
