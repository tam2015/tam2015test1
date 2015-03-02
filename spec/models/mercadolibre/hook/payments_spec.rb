require 'rails_helper'

RSpec.describe Mercadolibre::Hook::Payments, :type => :model do

  before(:all) do
    @hook = Mercadolibre::Hook::Payments.new data_payment
  end

  it "should extract id from resource" do
    expect(@hook.id).to eql("860855023")
  end

  def data_payment
    ActionController::Parameters.new({
      application_id: 5227026097385184,
      resource:       "/payments/860855023",
      user_id:        158748360,
      topic:          "payments",
      attempts:       18,
      sent:           "2014-09-20T07:49:24.417Z",
      received:       "2014-09-19T20:04:40.185Z"
    })
  end
end
