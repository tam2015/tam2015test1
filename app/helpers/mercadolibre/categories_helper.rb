module Mercadolibre::CategoriesHelper

  # recursive to root category
  def render_parents_of_category category

    parents = category.path_from_root.reverse
    categories = []
    parents.each do |parent|
      parent.children_categories = [categories].flatten(1)
      categories = parent
    end

    render_categories [categories], category
  end

  def render_category category, selected = nil
    selected_id = (selected || Meli::Category.new).id

    class_name  = category.id == selected_id ? "active" : ""
    is_children = category.respond_to?(:children_categories)
    children    = is_children ? category.children_categories : []

    content = []

    if category.id == selected_id
      content << link_to("", class: "btn btn-success btn-sm dd-right-button disabled", title: t(".selected")) do
        content_tag(:i, "", class: "fa fa-check") +
        content_tag(:span, t(".selected"), class: "sr-only")
      end
    elsif !selected_id
      if !is_children
        content << button_tag(t(".expand"), type: :button, "data-action" => "load")
      elsif is_children && children.empty?
        content << link_to("#", class: "btn btn-info btn-sm dd-right-button" , "data-action" => "select", title: t(".select")) do
          content_tag(:i, "", class: "fa fa-check") +
          content_tag(:span, t(".select"), class: "sr-only")
        end
      end
    end

    content << content_tag(:div, category.name, class: "dd-name" )
    content << render_categories(children, selected) if is_children && !children.empty?

    data = {
      id: category.id,
      name: category.name,
      children: (is_children ? children.empty? : nil)
    }

    content_tag(:li, class: "dd-item #{class_name}", id: category.id, data: data) do
      content.join("\n").html_safe
    end
  end

  def render_categories categories, selected = nil
    content_tag(:ol, class: "dd-list") do
      categories.map do |category|
        render_category category, selected
      end.join("\n").html_safe
    end.html_safe
  end
end
