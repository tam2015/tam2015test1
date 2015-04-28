# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  meli_user_username     :string(40)
#  phone                  :string(255)
#  role                   :string(255)      default("regular")
#  account_id             :integer
#  created_at             :datetime
#  updated_at             :datetime
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  invitations_count      :integer          default(0)
#  address                :hstore
#  codigo                 :string(255)
#  filial                 :string(255)
#  razaosocial            :string(255)
#  fantasia               :string(255)
#  cnpj                   :string(255)
#  telefone               :hstore
#  tipo_cliente           :string(255)
#  id_brands              :hstore
#  latitude               :float
#  longitude              :float
#  dashboards_count       :integer          default(0), not null
#

class User < ActiveRecord::Base
  include Provider::ModelBase

  mount_uploader :image, CwaveUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :invitable, :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login, :meli

  # Grupos de usuários:
  # Admin possui permissão global
  # Regular possui permissões especificas
  # Guest possui permissões de visitantes
  ROLES = %w(admin regular guest)

  # Associations
  belongs_to :account

  has_many :identities, dependent: :destroy

  has_many :boxes
  has_many :users_to_customers
  has_many :customers, through: :users_to_customers

  has_many :schedules
  has_many :subscriptions

  has_many :invitations, class_name: self.to_s, as: :invited_by

  has_many :users_to_dashboards
  has_many :dashboards, through: :users_to_dashboards


  before_validation :normalize_email, on: :create

  geocoded_by     :address
  before_save   :geocode
  #after_create    :send_welcome_email
  before_destroy  :destroy_dashboards
  #after_save      :associate_user_with_dashboards
  #after_save :default_steps

  # after_find :set_meli
  #
  scope :with_dashboards          , -> { joins(:dashboards) }
  scope :with_account_subscription, -> { includes(account: :subscription) }
  scope :with_account_status      , -> {
    includes(account: :subscription)
    .references(:subscriptions)
    .select("users.*, subscriptions.status, subscriptions.expires_in")
  }
  # scope :with_account_boxes_count, -> { includes(account: :boxes).account.boxes.count }

  # scope :with_dashboards_count, -> {
  #   joins(:users_to_dashboards).select('users.id, COUNT(dashboard_id) AS dashboard_count').group("users.id")
  #   # SELECT COUNT(dashboard_id) AS dashboard_count FROM "users" INNER JOIN "users_to_dashboards" ON "users_to_dashboards"."user_id" = "users"."id" GROUP BY users.id;
  # }


  # validations
  # validates :name,  presence: { unless: lambda { self.new_record? } },
  #                   format: { with: /\A[a-zA-Z]+\z/ },
  #                   length: { minimum: 3, maximum: 50 }

  # validates :phone, presence: true, numericality: { only_integer: true }, length: {minimum: 10, maximum: 15}

  ### Avatar
  # include AvatarUploader::Asset
  # mount_uploader :avatar, AvatarUploader
  # delegate :url, :current_path, :size, :content_type, :filename, to: :avatar

  ### Model Class



  def self.find_for_oauth(auth, signed_in_resource = nil)
    provider = auth.provider

    Rails.logger.debug "\n ##{provider.capitalize}Response= #{auth.to_json} \n"

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?
      user = where(email: auth.info.email).first_or_initialize.tap do |user|
        user.email      = auth.info.email
        user.password   = Devise.friendly_token[0,20]
        user.first_name = auth.info.first_name
        user.last_name  = auth.info.last_name
        user.meli_user_username = auth.info.username
        user.account    = Account.new

        # assuming the user model has an image
        # if auth.info.image
        #   user.image = auth.info.image
        #   user.image = "https://graph.facebook.com/#{auth.uid}/picture?type=large&width=256"
        #   user.remote_avatar_url= "https://graph.facebook.com/#{auth.uid}/picture?type=large&width=256"
        # end



        # user.skip_confirmation!
        user.save!


      end
    end

    #Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end

    # Find or create dashboard with oauth credentials
    unless Dashboard.find_for_oauth(auth, user)
      Rails.logger.debug " :::::   User.find_for_oauth #update_token: #{auth.to_json}\n"
      Dashboard.update_token(auth)
    end

    user
  end

  # User.current
  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def self.import(file, current_user)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)

    if header.include?("email")
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        # Rails.logger.info "\n\n\n"
        # Rails.logger.info "   row: #{row.to_json}"
        # Rails.logger.info "\n\n\n"

        attrs = {
          role:       "lojista",
          email:      row["email"       ],
          first_name: row["first_name"  ],
          last_name:  row["last_name"   ],
          phone:      row["phone"       ],
          account_id: current_user.account_id,
          codigo: row["codigo"],
          filial: row["filial"],
          razaosocial: row["razaosocial"],
          fantasia: row["fantasia"],
          cnpj: row["cnpj"],
          tipo_cliente: row["tipo_cliente"],
          address: {
            endereco: row["endereco"],
            bairro: row["bairro"],
            complemento: row["complemento"],
            cep: row["cep"],
            cidade: row["cidade"],
            estado: row["estado"]
          },
          telefone: {
            ddd: row["ddd"],
            telefone: row["telefone"]
          },
          id_brands: {
            mor: row["mor"],
            bea: row["bea"],
            mar: row["mar"],
            joy: row["joy"],
            zin: row["zin"],
            zma: row["zma"],
            mrs: row["mrs"],
            jbe: row["jbe"],
            leb: row["leb"]
          }
        }

         user_invited = invite!(attrs, current_user)
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, { file_warning: :ignore })
    when ".xls" then Roo::Excel.new(file.path, { file_warning: :ignore })
    when ".xlsx" then Roo::Excelx.new(file.path, { file_warning: :ignore })
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.user_brands(user)
    id_brands = user.id_brands
    if id_brands
      id_brands.delete_if{|key, value| value == nil }
      brands = id_brands.keys
    end
  end

  def self.associate_user_with_dashboards
    id_brands = self.id_brands
    if id_brands
      id_brands.delete_if{|key, value| value == nil }
      brands = id_brands.keys
    end
  end

  def self.reset_dashboards_counter!
    self.all.each do |user|
      user.update(dashboards_count: (user.dashboards.count || 0))
    end
  end

  def self.associate_near_user(shipping, box)
    if shipping_coordinates = shipping.coordinates
      users = User.near(shipping_coordinates, 200000)
      item = Mercadolibre::Item.where(meli_item_id: box.meli_item_id).first
      user = nil
        if users.each do |user|
          storage = Mercadolibre::Storage.where(user_id: user.id, meli_item_id: item.id).first if item
          break
          if user = user
            shipping.update(user_id: user.id)
          end
          storage.update(l_quantity: storage.l_quantity - 1) if storage
        end

        if user
          if box = Box.where(meli_order_id: shipping.meli_order_id).first
              box.update(user_id: user.id)
          end

          if payment = Mercadolibre::Payment.where(meli_order_id: shipping.meli_order_id).first
            payment.update(user_id: user.id)
          end
        end
      end
    end
  end

  def associate_user_with_dashboards
   id_brands = self.id_brands
   if id_brands
     id_brands.delete_if{|key, value| value == nil }
     brands = id_brands.keys
   end
   dashboards = Dashboard.where(name: brands) #criar atributo
     if dashboards.each do |dashboard|
       UsersToDashboard.create(
         user_id:          self.id,
         dashboard_id:     dashboard.id,
         role:             nil #lojista[]
         )
     end
   end
  end

  ### Helpers

  def name
    [first_name, last_name].compact.join("\s")
  end

  # defining roles
  def admin?
    self.role == "admin"
  end

  def regular?
    self.role == "regular"
  end

  def guest?
    self.role == "guest"
  end

  def lojista?
    role == "lojista"
  end

  def last_login
    self.last_sign_in_at.utc.iso8601 if self.last_sign_in_at
  end

  def account_status
    self.account.subscription.status
  end

  def subscription_date_expiration
    if account && account.subscription.present? && account.subscription.expires_in
      account.subscription.expires_in.utc.iso8601
    end
  end

  def dashboard_permissions
    UsersToDashboard.where(user_id: id)
  end

  ### Métodos personalizados

  def send_welcome_email
    #Mailing::Notify.welcome.delay(queue: :seldom, retry: false).welcome_email(self).deliver unless self.invalid?
    #Mailing::Notify.welcome(self).deliver unless self.invalid?
  end

  # Destroi todos os dashboards relacionados (caso seja unico proprietário)
  def destroy_dashboards
    self.dashboards.map do |dashboard|
      if dashboard.users.count == 1
        dashboard.destroy
      end
    end
  end



  def as_csv(options = {})
    attrs =
      {
        "name" => name
      }.merge attributes.slice(*%W(email first_name last_name phone))
  end

  def as_xls(options = {})
    attrs =
      {
        "name" => name
      }.merge attributes.slice(*%W(email first_name last_name phone))
  end

  def xls_options
    {
      columns: [
        :name,
        :email,
        :phone,
        :address,
        :role,
        :dashboards_count,
        :account_status,
        :sign_in_count,
        :last_login,
        :subscription_date_expiration,
        :invitations_count,
        :invited_by_id
      ],
      headers: [
        'Name',
        'E-mail',
        'Phone',
        'Address',
        'Role',
        'Dashboards',
        'Account type',
        'Logins',
        'Last login',
        'Expires in',
        'Invitations sent',
        'Invited By'
      ]
    }
  end




  private

  protected

  def normalize_email
    self.email  = self.email.downcase unless self.email.blank?
  end
end
