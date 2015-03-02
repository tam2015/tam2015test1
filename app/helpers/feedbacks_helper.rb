module FeedbacksHelper

def feedback_seller(buyer_feedback)
  @feedback_seller =  Mercadolibre::Feedback.where(meli_order_id: buyer_feedback.meli_order_id, author_type: "seller").first
end

def box order_id
  @box = Box.where(meli_order_id: order_id).first
end


end
