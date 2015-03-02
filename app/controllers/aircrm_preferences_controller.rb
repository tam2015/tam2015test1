class AircrmPreferencesController < ApplicationController

  def new
    @aircrm_preference = AircrmPreference.new
  end

  def create
    if @aircrm_preference = AircrmPreference.create(aircrm_preference_params)
      redirect_to  dashboard_aircrm_preferences_path(dashboard_id: current_user.dashboards.first.id, preference_type: params[:aircrm_preference][:preference_type])
    else
      puts "não foi possivel"
    end
  end

  def index
    @seller_feedback_messages = AircrmPreference.where(dashboard_id: current_dashboard.id, preference_type: params[:preference_type] )
  end

  private

  def aircrm_preference_params
    data_params = [ :answer, :tags, :time, :aircrm_reason, :content ]
    params.require(:aircrm_preference).permit(:preference_type, :account_id, :dashboard_id, data: data_params)
  end

end
