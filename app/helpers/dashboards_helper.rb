module DashboardsHelper

  def current_dashboard
    @current_dashboard ||= if params[:controller] == "dashboards" and !params[:id].nil?
      Dashboard.find(params[:id])
    elsif params[:dashboard_id]
      Dashboard.find(params[:dashboard_id])
    end
  end

  def user_dashboard_owner?
    current_user.dashboards.include? current_dashboard if current_dashboard
  end

  # For callbacks
  # Use callbacks to share common setup or constraints between actions.
  def set_dashboard(dashboard_id=nil)
    # carrega o current_dashboard_id caso exista
    current_dashboard_id = current_dashboard ? current_dashboard.id : nil
    # carrega o dashboard_id do params caso exista
    dashboard_id ||= params.include?(:dashboard_id) ? params[:dashboard_id] : nil

    # Carrega o dashboard caso:
    # current_dashboard.id != params[dashboard_id]
    #   Se existir o :dashboard_id em params compara para ver se não é o mesmo do current_dashboard
    load_dashboard = dashboard_id and dashboard_id != current_dashboard_id

    @dashboard = load_dashboard ? Dashboard.find(dashboard_id) : current_dashboard
  end
end
