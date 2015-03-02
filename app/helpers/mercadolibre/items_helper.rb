module Mercadolibre::ItemsHelper
  # Application Helpers
  include Mercadolibre::CategoriesHelper

  def status_links status
    #   - @klass::STATUS.each do |tag|
    # label.label-default= t(tag, scope: "helpers.items.status")
  end

  def status_label(labels, options = {})
    options = {
      scope: "helpers.items.status",
      label_class_append: nil         # "label-block"
      }.merge(options)

    [labels].flatten.map do |label|
      style = status_style label

      content_tag(:span, t(label, scope: options[:scope] ), class: "label label-#{style} #{options[:label_class_append]}")
    end.join("\n").html_safe
  end

  def status_style label
    case label.to_sym
      when :payment_required  then "danger"
      when :active, :valid    then "success"
      when :paused            then "info"
      when :inactive          then "inverse"
      when :under_review      then "warning"

      else "default"
    end
  end
end
