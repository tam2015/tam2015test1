require 'rails_helper'

RSpec.describe Webhook, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe "initialize success" do
    before(:all) do
      @webhook = Webhook.new "mercadolibre", data_order
    end

    it "should provider" do
      expect(@webhook.provider).to eql(:mercadolibre)
    end

    it "should provider_name" do
      expect(@webhook.provider_name).to eql("Mercadolibre")
    end

    it "should hook topic" do
      expect(@webhook.hook_topic).to eql("Orders")
    end

    it "should data" do
      expect(@webhook.data).to eql(data_order)
    end

    it "should provider hook class name" do
      expect(@webhook.hook_class_name).to eql("Mercadolibre::Hook::Orders")
    end

    it "should provider hook class" do
      expect(@webhook.hook_class).to eql(Mercadolibre::Hook::Orders)
    end

    it "should hooked class" do
      expect(@webhook.hook.class).to eql(Mercadolibre::Hook::Orders)
    end
  end

  describe "initialize without" do
    it "provider and webhook" do
      expect{ Webhook.new }.to raise_error(ArgumentError, "wrong number of arguments (0 for 2)")
    end

    it "provider" do
      expect{ Webhook.new nil, data_order }.to raise_error(ArgumentError, /provider can not be null/)
    end

    it "webhook" do
      expect{ Webhook.new "mercadolibre" }.to raise_error(ArgumentError, "wrong number of arguments (1 for 2)")
    end
  end


  def data_order
    ActionController::Parameters.new({
      application_id: 5227026097385184,
      resource:       "/orders/860855023",
      user_id:        158748360,
      topic:          "orders",
      attempts:       18,
      sent:           "2014-09-20T07:49:24.417Z",
      received:       "2014-09-19T20:04:40.185Z"
    })
  end
end
