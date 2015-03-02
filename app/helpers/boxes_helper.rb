module BoxesHelper
  def shipping_status_label status, box
    link_to(
      dashboard_box_path(current_dashboard, box),
      class: shipping_status_label_class(status),
      title: t(status, scope: "helpers.boxes.status_title")
    ) do
      content_tag(:i, nil, class: "fa fa-truck")
    end
  end

  def shipping_status_label_class status
    status_class = case status.to_sym
      when :shipping_to_be_agreed, :shipping_cancelled  then "danger"
      when :shipping_pending, :shipping_handling, :shipping_not_delivered      then "warning"
      when :shipping_delivered            then "info"

      when :shipping_shipped            then "success"
      when :shipping_ready_to_ship, :shipping_not_verified          then "inverse"

      else "default"
    end
    "label label-#{status_class} label-#{status}"
  end

  def feedback_buyer(box)
    @feedback_buyer = Mercadolibre::Feedback.where(meli_order_id: box.meli_oerder_id, author_type: "buyer").first
  end

  def list_of_tags
    @tags =
    [
      ["paid","delivered"],
      ["paid", "not_delivered"],
      ["not_paid", "delivered"],
      ["not_paid", "not_delivered"]
    ]
  end

  def list_of_payment_tags
    @tags = %W(to_be_agreed pending approved in_process rejected cancelled refunded in_mediation charged_back)
  end

  def list_of_shipping_tags
    @tags = %W(to_be_agreed pending handling shipped delivered not_delivered cancelled)
  end


  def humanize_box_tags(tags, payment, shipping)
    tags_not_to_delete = %W(to_be_agreed pending approved in_process rejected cancelled refunded in_mediation charged_back to_be_agreed pending handling shipped cancelled)
    tags_to_delete = %W(paid not_paid delivered not_delivered)
    tags_not_to_delete.each do |tag_not_to_delete|
      if tags.include?(tag_not_to_delete)
        tags_to_delete.each do |tag_to_delete|
          tags.delete(tag_to_delete)
        end
      end
    end

    payment.tags = [] if !payment.tags.present?
    shipping.tags = [] if !shipping.tags.present?

    if payment.tags.include?("pending") and !shipping.tags.include?("pending")
      tags.delete("pending")
      tags << "pending_payment"
    elsif shipping.tags.include?("pending") and !payment.tags.include?("pending")
      tags.delete("pending")
      tags << "pending_shipping"
    elsif shipping.tags.include?("pending") and payment.tags.include?("pending")
      tags.delete("pending")
      tags << "pending_payment"
      tags << "pending_shipping"
    end

    if payment.tags.include?("cancelled") and !shipping.tags.include?("cancelled")
      tags.delete("cancelled")
      tags << "cancelled_payment"
    elsif shipping.tags.include?("cancelled") and !payment.tags.include?("cancelled")
      tags.delete("cancelled")
      tags << "cancelled_shipping"
    elsif shipping.tags.include?("cancelled") and payment.tags.include?("cancelled")
      tags.delete("cancelled")
      tags << "cancelled_payment"
      tags << "cancelled_shipping"
    end

    if payment.tags.include?("to_be_agreed") and !shipping.tags.include?("to_be_agreed")
      tags.delete("to_be_agreed")
      tags << "payment_to_be_agreed"
    elsif shipping.tags.include?("to_be_agreed") and !payment.tags.include?("to_be_agreed")
      tags.delete("to_be_agreed")
      tags << "shipping_to_be_agreed"
    elsif shipping.tags.include?("to_be_agreed") and payment.tags.include?("to_be_agreed")
      tags.delete("to_be_agreed")
      tags << "payment_to_be_agreed"
      tags << "shipping_to_be_agreed"
    end

    if !payment.tags?
      tags << "payment_to_be_agreed"
    elsif !shipping.tags?
      tags << "shipping_to_be_agreed"
    elsif !shipping.tags? and !payment.tags?
      tags << "shipping_to_be_agreed"
      tags << "payment_to_be_agreed"
    end

    tags.map! { |tag| I18n.t(tag, scope: "helpers.boxes.box_tags", default: tag) }
    #tags.join(', ')
  end

end


