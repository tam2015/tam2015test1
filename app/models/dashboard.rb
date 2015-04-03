# == Schema Information
#
# Table name: dashboards
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  provider           :string(20)
#  meli_user_id       :integer
#  token              :string(255)
#  refresh_token      :string(255)
#  token_expires_at   :string(255)
#  account_id         :integer
#  created_at         :datetime
#  updated_at         :datetime
#  synced_at          :datetime
#  preferences        :hstore
#  boxes_count        :integer          default(0), not null
#  meli_user_username :string(40)
#

class Dashboard < ActiveRecord::Base
  include Provider::ModelBase

  # Associations
  has_many :boxes, dependent: :destroy

  belongs_to :user
  belongs_to :account

  has_many :users_to_dashboards
  has_many :users, through: :users_to_dashboards

  has_many :aircrm_preferences

  # HSTORE
  serialize :preferences, DashboardPreferences

  # CALLBACKS
  after_find :load_provider

  #after_create  :increment_users_counter
  #after_destroy :decrement_users_counter

  def self.find_for_oauth(auth, user)
    return unless user or !user.is_a? User
    dashboard = self.where(meli_user_id: auth.uid.to_i, provider: auth.provider).first_or_initialize
    dashboard.meli_user_username = auth.info.username # TODO: what happens here?
    dashboard.name              = "Mercado Livre" #I18n.t("providers.#{auth.provider}.name")
    #dashboard.user_ids          = [user.id]
    dashboard.account_id        = user.account.id

    if auth.provider == "mercadolibre" and auth.extra.present? and auth.extra.raw_info.present?
      dashboard.preferences.country_id                = auth.extra.raw_info.country_id
      dashboard.preferences.site_id                   = auth.extra.raw_info.site_id
      dashboard.preferences.mercadopago_tc_accepted   = auth.extra.raw_info.status.mercadopago_tc_accepted
      dashboard.preferences.mercadopago_account_type  = auth.extra.raw_info.mercadopago_account_type
      dashboard.preferences.mercadoenvios             = auth.extra.raw_info.status.mercadoenvios
      dashboard.preferences.shipping_modes            = auth.extra.raw_info.shipping_modes
      dashboard.preferences.seller_address            = auth.extra.raw_info.address

      meli_registration_date                          = auth.extra.raw_info.registration_date.to_date
      time_of_meli                                    = Time.now.to_date - meli_registration_date
      time_of_meli_to_months                          = time_of_meli.to_i/365.0*12
      number_of_transactions                          = auth.extra.raw_info.seller_reputation.transactions.total
      average_transactions_per_month                  = number_of_transactions/time_of_meli_to_months
      dashboard.preferences.average_sales             = average_transactions_per_month
    end

    sync_account = dashboard.new_record?

    # update credentials
    dashboard.token             = auth.credentials.token
    dashboard.refresh_token     = auth.credentials.refresh_token
    dashboard.token_expires_at  = Time.at(auth.credentials.expires_at).to_i
    dashboard.save

    UsersToDashboard.find_or_create_by(user_id: user.id, dashboard_id: dashboard.id)

    # reload provider
    dashboard.load_provider

    # fire workers
    if sync_account and dashboard.preferences.average_sales < 1000
      Mercadolibre::AccountSyncWorker.perform_async dashboard.id
    end

    dashboard
  end

  def self.reset_boxes_counter!
    self.all.each do |dashboard|
      dashboard.update(boxes_count: (dashboard.boxes.count || 0))
    end
  end

  # Helpers
  def synced!
    update(synced_at: Time.current)
  end

  def provider
    super.downcase
  end

  def provider=(p)
    super p.downcase
  end

  def owner
    @user = users.first
  end

  # def synced?
  #   synced_at.nil?
  # end

  def credentials
    {
      access_token: token,
      refresh_token: refresh_token,
      expires_at: token_expires_at
    }
  end

  def increment_users_counter
    self.users.each { |user| user.increment!(:dashboards_count) }
  end

  def decrement_users_counter
    self.users.each { |user| user.decrement!(:dashboards_count) }
  end

  # Providers
  def load_provider
    if self.respond_to?(:provider?) and self.provider?
      # Send oauth credentials to Meli
      if defined? Meli
        Meli::Base.oauth_connection= self.credentials
        Meli::Base.user_id= self.meli_user_id
      end

      unless self.class.provider?
        Providers.load_models self.provider
      end

      Providers.load_provider( self.provider, {
        credentials: {
          token:            self.token,
          refresh_token:    self.refresh_token,
          token_expires_at: self.token_expires_at
        }
      })
    end
  end

end
