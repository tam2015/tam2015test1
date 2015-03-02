module ApplicationHelper
  # Core Helpers
  include DeviseHelper
  include UsersHelper
  include AccountsHelper
  include RoutesHelper
  include I18nHelper

  # Application Helpers
  include DashboardsHelper


  # Modal?
  # Flash Message
  # Exibe as mensagens de erro estilizadas para o bootstrap
  def flash_message(scope=nil)
    scoped = scope.nil? ? flash : flash[scope]
    flash.discard

    html_data = scoped.map do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      return message if message.blank?

      [message].flatten.map do |msg|
        content_tag(:div, class:"flash-message fade in #{flash_class(type)} #{type} alert-dismissable") do
          content_tag(:button, raw("&times;"), class:"close", "data-dismiss" => "alert") +
          msg.to_s.html_safe
        end if msg
      end
    end
    html_data.join("\n").html_safe
  end

  def flash_class(level)
    case level.to_sym
      when :notice  , :info     then "alert alert-info"
      when :success , :success  then "alert alert-success"
      when :error   , :danger   then "alert alert-danger"
      when :alert   , :warning  then "alert alert-warning"
    end
  end

  # Dispatcher
  def controller_name
    controller_name = controller_path.gsub(/\//, "_")
  end

  def dispatcher_route
    "#{controller_name}##{action_name}"
  end

  def dispatcher_class
    "#{controller_name} #{controller_name}-#{action_name}"
  end

end
