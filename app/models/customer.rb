# == Schema Information
#
# Table name: customers
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  nickname        :string(255)
#  phone           :string(255)
#  email           :string(255)
#  meli_user_id    :integer
#  user_id         :integer
#  account_id      :integer
#  created_at      :datetime
#  updated_at      :datetime
#  blocked         :boolean          default(FALSE)
#  pendings_status :string(255)
#  pendings        :string(255)      is an Array
#

class Customer < ActiveRecord::Base
  include Provider::ModelBase

  belongs_to :account


  has_many :boxes
  has_many :users_to_customers
  has_many :users, through: :users_to_customers

  before_save :update_pendings
  before_save :update_pendings_status

  default_scope  { order(:id => :desc) }


  def update_pendings
    self.pendings = []

    if !self.phone.present?
      self.pendings = ["no_phone"]
    end
  end


  def update_pendings_status
    self.pendings_status = "no_pending"

    ["no_phone"].each do |pedding_message|
      if self.pendings.include?(pedding_message)
        self.pendings_status = "pending"
        break
      end
    end
  end



  def self.parse(meli_customer, meli_seller)
    # return nil unless account.instance_of? Account

    # Busca o primeiro ou cria o customer do usuário com o meli_user_id da ordem
    customer           = where({ meli_user_id: meli_customer.id }).first_or_initialize
    customer.name      = [meli_customer.first_name?, meli_customer.last_name?].join("\s")
    customer.phone     = phone_to_s(meli_customer.phone?)
    customer.email     = meli_customer.email?
    customer.nickname  = meli_customer.nickname?
      #b.address   = meli_buyer.address?
    saved = customer.save

    if saved
      user_to_customer = UsersToCustomer.where(customer_id: customer.id, user_id: meli_seller.id).first_or_initialize
      user_to_customer.save
    end
    customer
  end

  def self.get_customer(user_id, customer_id)
    if user_id and customer_id
      # Fetch Item fom Meli
      meli_customer  = Meli::User.find(customer_id)
      meli_seller = Dashboard.find_by(meli_user_id: user_id).users.first

      # Update Customer
      unless customer = Customer.where({ meli_user_id: meli_customer.id }).first
        Customer.parse(meli_customer, meli_seller)
      end
    end
  end


  def self.phone_to_s(phone)
    return nil if phone.nil?

    demodulized_class = phone.class.to_s.demodulize
    if demodulized_class == "Phone"
      phone_s = [phone.area_code?, phone.number?].compact.join.gsub(/[^0-9]/, "")
      phone_s = [phone_s, phone.extension?].compact.join("-")
    else
      nil
    end
  end

  def username
    "@#{nickname}"
  end

  def question dashboard_id
    dashboard = Dashboard.find dashboard_id
    question = Mercadolibre::Question.where(author_id: meli_user_id, seller_id: dashboard.meli_user_id).first
  end

  def questions_count dashboard_id
    dashboard = Dashboard.find dashboard_id
    question = Mercadolibre::Question.where(author_id: meli_user_id, seller_id: dashboard.meli_user_id).count
  end
end
