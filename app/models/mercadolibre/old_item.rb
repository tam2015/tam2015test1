# module Mercadolibre
#   class Item < ActiveRecord::Base
#     include Provider::ModelBase

#     serialize :description

#     # Item status. Possible values:
#       # auction: Auction
#       # buy_it_now:  Buy it now (Fixed price)
#       # classified:  Classified (Motors, Real Estate, Services)
#     enum buying_mode: [ :buy_it_now, :auction, :classified ]#, default: :buy_it_now

#     # Item listing_type_id. The listing type ID reflects the exposure of the item.
#     #   Possible values:
#       # gold_premium:  Gold Premium
#       # gold:  Gold
#       # silver:  Silver
#       # bronze:  Bronze
#       # free:  Free
#     enum listing_type_id: [ :gold_special, :gold_premium, :gold, :silver, :bronze, :free ]#, default: :free

#     # Item status. Possible values:
#       # empty: Item is empty, it was created but not filled
#       # unpublished: The item is not published
#       # invalid_data: The item is not valid to publishe
#       # -- MercadoLibre status:
#       # not_yet_active:  The item is waiting for activation
#       # payment_required:  Requires the seller pays the listing fee before activation
#       # paused:  The item was paused by the seller or other reason
#       # active:  Active
#       # closed:  Closed
#       # under_review:  The item is being reviewed by MercadoLibre
#       # inactive:  Inactive
#     enum status: [ :empty, :unpublished, :invalid_data, :not_yet_active, :payment_required, :paused, :active, :closed, :under_review, :inactive ]

#     # Item sub_status. Internal modifiers and/or statuses.
#     #   Possible values:
#       # deleted: The item was marked as deleted from MyML account
#       # banned:  Banned
#       # waiting_for_patch: Suspended until the seller ammends the item
#       # held:  Temporal suspended
#       # freezed: Suspended due ToC infringements
#       # suspended: Suspended due credit policies infringements
#     # enum :sub_status, [ :deleted, :banned, :waiting_for_patch, :held, :freezed, :suspended ], required: false, multiple: true


#     CONDITIONS = %w(new used not_specified)
#     # in item replace "not_specified" to "unespecified"


#     # Payments

#     # {
#     #   "id": "MLBMO",
#     #   "description": "Dinheiro",
#     #   "type": "G"
#     # }, {
#     #   "id": "MLBCC",
#     #   "description": "Cartão de Crédito",
#     #   "type": "N"
#     # }, {
#     #   "id": "MLBDE",
#     #   "description": "Depósito Bancário",
#     #   "type": "D"
#     # }
#     # array with IDs

#     # Shipping
#     # Custom shipping: use costs attributes.
#       # More info in http://developers.mercadolibre.com/custom-shipping-examples/

#     # Validation
#     # code: http status of validation response
#       # 200..299      - ok
#       # 301..303, 307 - redirecting
#       # 300..399      - non-redirecting 3xx statuses
#       # 402           - payment required
#       # 400..599      - all errors statutes


#     attr_accessor :category, :youtube_url




#     ### Aliases
#     alias_attribute :seller_id, :meli_user_id
#     alias_attribute :date_created, :created_at
#     alias_attribute :last_updated, :updated_at

#     ### Scopes
#     #default_scope -> { desc(:stop_time) }


#     # ## Callbacks
#     YOUTUBE_REGEX = /(?:youtu\.be\/|youtube\.com(?:\/embed\/|\/v\/|\/watch\?v=|\/user\/\S+|\/ytscreeningroom\?v=|\/sandalsResorts#\w\/\w\/.*\/))([^\/&]{10,12})/
#     before_validation :get_youtube_id
#     #before_validation :shipping_costs_compact


#     # mount_uploaders :pictures_uploaded, ImageUploader
#     has_many :variations
#     has_one :item_storage
#     has_one :meli_info
#     has_many :pictures

#     ### Validations
#     # 1. Para anunciar em Diamante é necessesário adicionar fotos.

#     # validates :title, :category_id,
#     #   # Validate associations
#     #   :account_id#, :user_id,
#     #   # Role
#     #   presence: { unless: lambda { self.new_record? } }



#     # Virtual Attribute
#     def category
#       if category_id?
#         if defined?(@category) and category_id == @category.id
#           @category
#         else
#           @category = ::Meli::Category.find(category_id)
#         end
#       end
#     end

#     def category=(record)
#       if record.kind_of? ::Meli::Category
#         category_id = record.id
#         @category   = record
#       end
#     end

#     def category?
#       !!category_id
#     end

#     def youtube_url
#       if @youtube_url.nil? and self.video_id?
#         @youtube_url = "http://www.youtube.com/watch?v=#{self.video_id}"
#       end
#       @youtube_url
#     end

#     # Import
#     def self.import(file, dashboard)
#       spreadsheet = open_spreadsheet(file)
#       header = spreadsheet.row(1)

#       if header.include?("title")


#         (2..spreadsheet.last_row).each do |i|
#           row = Hash[[header, spreadsheet.row(i)].transpose]
#           item = where(title: row["title"], dashboard_id: dashboard.id).first_or_initialize #|| new
#           item.attributes = row.to_hash.slice("title", "condition", "site_id", "price", "initial_quantity",  "description", "accepts_mercadopago", "category_id", "official_store_id", "warranty", "available_quantity", "catalog_product_id", "video_id")
#           item.non_mercado_pago_payment_methods     = ["MLBCC", "MLBMO", "MLBDE"]
#           item.start_time                           = Time.now.to_s
#           #item.pictures                             = [{"source": "http://www.apertura.com/export/sites/revistaap/img/Tecnologia/Logo_ML_NUEVO.jpg_33442984.jpg"]}
#           #item.price                                = Mercadolibre::Item.last.price
#           #item.save!
#           print "\n\n\n\n\n\n\n\n\n\n------------price-> #{item.price.to_json}\n\n\n\n\n\n\n\n\n\n------------"
#           print "\n\n\n\n\n\n\n\n\n\n------------price-> #{item.start_time}\n\n\n\n\n\n\n\n\n\n------------"
#           item.validate_in_meli!
#         end
#       end
#     end

#     # This will be used bu  franquiador to import the catalog. It needs to be modified. Please do not delete.
#     # def self.import(file)
#     #   spreadsheet = open_spreadsheet(file)
#     #   header = spreadsheet.row(1)

#     #   if header.include?("f_codigo") && header.include?("f_descricao") && header.include?("f_colecao") && header.include?("f_marca")


#     #     (2..spreadsheet.last_row).each do |i|
#     #       row = Hash[[header, spreadsheet.row(i)].transpose]
#     #       item = where(:f_codigo => row["f_codigo"], :f_descricao => row["f_descricao"].to_s ).first_or_initialize #|| new
#     #       item.attributes = row.to_hash.slice("f_codigo", "f_descricao", "f_colecao", "f_marca", "f_referencia", "f_grupo", "f_linha", "f_storage", "f_subgrupo", "f_preco_venda", "f_preco_custo")
#     #       item.save!
#     #     end
#     #   end
#     # end

#     def self.open_spreadsheet(file)
#       case File.extname(file.original_filename)
#       when ".csv" then Roo::Csv.new(file.path, { file_warning: :ignore })
#       when ".xls" then Roo::Excel.new(file.path, { file_warning: :ignore })
#       when ".xlsx" then Roo::Excelx.new(file.path, { file_warning: :ignore })
#       else
#         raise "Unknown file type: #{file.original_filename}"
#       end
#     end

#     # Export
#     def as_json(options = nil)
#       options = {
#                   include: {
#                     pictures: {
#                       methods: [ :size, :content_type ]
#                     }
#                   }
#                 }.merge(options || {})

#       hash = super(options)

#       hash.delete("descriptions")

#       unless category.nil?
#         hash[:category] = category.serializable_hash
#       end

#       hash.merge({
#         "status"          => hash.delete("_status"         ),
#         "buying_mode"     => hash.delete("_buying_mode"    ),
#         "listing_type_id" => hash.delete("_listing_type_id")
#         })
#     end

#     # API
#     def to_meli(persisted=nil, filter_attributes = nil)
#       old_hash = serializable_hash(include: [:pictures])
#       hash = ActiveSupport::HashWithIndifferentAccess.new

#       old_hash.each do |key, value|

#         key = case key.to_s
#               when "id"   then "aircrm_id"        # rename :id to :aircrm_id
#               when "meli_item_id"  then "id"               # rename :mid to :id
#               when /^_/   then key.gsub(/^_/, '') # remove "_" (underscore) of key to normalize enums
#               else key
#               end

#         hash[key.to_sym] = value
#       end

#       puts " -------  hash after filter: #{hash}"
#       puts " -------  hash after filter keys: #{hash.keys}"

#       if filter_attributes
#         # filter_attributes.map!(&:to_s)
#         puts " -------       filter_attributes: #{filter_attributes}"
#         hash.slice!(*filter_attributes)
#       end

#       if self.variations?
#         hash.delete(:pictures)
#         hash.delete(:price)
#         hash.delete(:available_quantity)

#         puts " -------       hash[:variations]: #{hash[:variations]}"

#         if self.pictures?
#           # hash[:variations] = []
#           puts "\n\n\n"
#           puts " -------       hash[:variations]: #{hash[:variations]}"

#           hash[:variations] = hash[:variations].map do |_variation|
#             variation = _variation.dup

#             variation[:price    ] = self.price
#             variation[:picture_ids ] = (variation[:picture_ids] || []).map do |picture_id|
#               if picture = self.pictures.find(picture_id)
#                 picture.full_url
#               end
#             end

#             puts " -------       variation[:picture_ids]: #{variation[:picture_ids]}"

#             # hash[:variations] << variation
#             variation
#           end
#         end
#       else
#         if self.pictures?
#           hash[:pictures] = []
#           self.pictures.each do |picture|
#             hash[:pictures] << picture.full_url
#           end
#         end
#       end

#       puts " -------  hash before filter: #{hash}"
#       puts " -------  hash before filter keys: #{hash.keys}"

#       if persisted.nil?
#         persisted = published_at? or !(self.new_record? || !self.meli_item_id.present?)
#       end

#       Meli::Item.new hash, persisted
#     end

#     def validate_in_meli
#       dashboard = Dashboard.find(dashboard_id) if !Meli::Item.oauth_connection and self.dashboard_id
#       record    = to_meli(false)

#       # attributes of the record is changed in response data
#       response = record.validate

#       # if :start_time, :stop_time, :end_time is nil, exclude use values of response
#       exclude_attributes = []
#       exclude_attributes << :start_time unless self.start_time?
#       exclude_attributes << :stop_time  unless self.stop_time?
#       exclude_attributes << :end_time   unless self.end_time?

#       attributes_to_get_values = self.class.attribute_names_sym - exclude_attributes

#       parsed_record = Mercadolibre::Item.parse_from_validation(record)
#       parsed_record.slice!(*attributes_to_get_values)
#       parsed_record[:id] = self.id.to_s
#       new_item = Mercadolibre::Item.load(parsed_record, self)

#       new_item
#     end

#     def validate_in_meli!
#       validate_in_meli
#       save
#     end

#     def publish_in_meli
#       # if not valid add error and skip publish
#       unless self.validation_status == :valid
#         self.errors.add(:validation_status, "Não é possível publicar um anuncio inválido para o Mercado Livre.")
#         return false
#       end

#       dashboard = Dashboard.find(dashboard_id) if !Meli::Item.oauth_connection and self.dashboard_id
#       record    = to_meli

#       # filter_attributes = [:buying_mode, :listing_type_id, :status, :title, :condition,
#       #                      :site_id, :currency_id, :price, :available_quantity,
#       #                      :accepts_mercadopago, :non_mercado_pago_payment_methods,
#       #                      :shipping, :seller_address, :location, :coverage_areas,
#       #                      :variations, :warranty, :seller_custom_field, :automatic_relist,
#       #                      :video_id,

#       #                      # :pictures, :description, :mid,
#       #                      :start_time, :category_id, :official_store_id, :catalog_product_id]


#       puts "\n\n"
#       puts " ------ publish ------"
#       puts " --> record.new? #{record.new?}"
#       puts " --> record #{record.to_json}"
#       puts " --> record changed? #{record.changed?}"
#       puts " --> record changes #{record.attributes_changed}"
#       puts " --> item changes #{self.changes}"

#       #
#       #
#       #
#       # Não está atualizando pois o record não detecta as alterações do item.
#       #
#       #
#       #
#       #
#       # if !record.changed? or record.attributes_changed.empty?
#       #   puts "SKIP - not changes to publish"
#       #   return true
#       # end

#       begin
#         _published = record.save
#       rescue OAuth2::Error => error
#         response = error.response
#         puts  "#{error.inspect}"

#         puts " --> error.message = #{error.message}"

#         puts " --> response.status = #{response.status}"
#         puts " --> response.headers = #{response.headers}"
#         puts " --> response.parsed = #{response.parsed}"
#         puts " --> response.body = #{response.body}"

#         case response.status
#         when 402
#           record.load_attributes_from_response(response)
#           _published = true
#         else
#           error
#           _published = false
#         end
#       end

#       puts " --> _published = #{_published}"

#       if _published
#         puts " --> record = #{record.inspect}"
#         parsed_record = Mercadolibre::Item.parse(record)
#         parsed_record[:id ] = self.id.to_s
#         parsed_record[:meli_item_id] = record.id
#         new_item = Mercadolibre::Item.load(parsed_record, self)
#         self.published_at = Time.current
#       else
#         puts " --> error = #{error.inspect}"
#         parsed  = response.parsed
#         causes  = parsed["cause"]

#         puts " --> response = #{response.inspect}"
#         puts " --> parsed = #{response.parsed}"

#         if causes.present?
#           cause = causes.first
#           error_name    = cause["code"].gsub(/^item\./, '')
#           error_message = cause["message"]
#         elsif parsed["message"] and parsed["error"]
#           error_name    = parsed["message"]
#           error_message = parsed["error"]
#         else
#           error_name    = response.status
#           error_message = "Ocorreu algum erro não defindo."
#         end

#         self.errors.add(error_name.to_s, error_message)
#       end


#       puts " ---------------------"
#       puts "\n\n"


#       _published
#     end

#     def publish_in_meli!
#       save if publish_in_meli
#     end

#     # Callbacks
#     # extract youtube video id from :youtube_url
#     def get_youtube_id
#       self.video_id = if self.youtube_url.present?
#         if match = YOUTUBE_REGEX.match(self.youtube_url)
#           match[1]
#         end
#       else
#         nil
#       end
#     end

#     # def shipping_costs_compact
#     #   if self.shipping.present? and self.shipping[:costs].present?
#     #     self.shipping[:costs].select! {|option| option["name"].present? or option["cost"].present? }
#     #   end
#     # end

#     # Mercadolibre::Item
#     # ClassMethods

#     def self.load_where_params(item)
#       {
#         meli_item_id: item.id,
#         meli_user_id: item.seller_id
#       }
#     end

#     # Parse attributes and load/create record
#     def self.load(attrs, item = nil)
#       return nil unless attrs.is_a? Hash
#       Rails.logger.debug "\n\n------------------------ load()  ----------------------------"
#       Rails.logger.debug "      attrs: #{attrs.to_json}"
#       Rails.logger.debug "      item: #{item.inspect}"

#       item = self.find(attrs[:id]) if item.nil?
#       Rails.logger.debug "\n"
#       Rails.logger.debug "      item: nil? = #{item.nil?} => #{item.inspect}"

#       Rails.logger.debug "\n"

#       unless item.nil?
#         attrs.delete(:pictures)
#         item.attributes= attrs
#         Rails.logger.debug "      item attributes: #{item.attributes}"
#         Rails.logger.debug "---------------------------------------------------- \n\n"
#         item
#       end
#     end

#     # load and save item
#     def self.load!(atttributes)
#       item = load(attributes)
#       item.save
#       item
#     end

#     # parses object from Meli validation
#     def self.parse_from_validation(record)
#       hash = {}

#       attrs = attribute_names_sym
#       attrs.delete(:id)         # salva o id do mercado livre com o attributo :mid
#       attrs.delete(:pictures)
#       attrs.delete(:variations)

#       # parse attributes
#       record_attributes = record.serializable_hash.symbolize_keys
#       hash = record_attributes.slice *attrs
#       # puts "------------------------ attrs: #{attrs} ---------------------------- \n\n"
#       # puts "------------------------ record: #{record.inspect} -------------------------------- \n\n\n"
#       # Description
#       description = record.description
#       unless description.is_a? String
#         description &&= description.serializable_hash.symbolize_keys
#       end

#       # Payments
#       hash[:non_mercado_pago_payment_methods] = (record.non_mercado_pago_payment_methods? || []).map do |non_mp_payment_method|
#         non_mp_payment_method.is_a?(Hash) ? non_mp_payment_method["id"] : non_mp_payment_method
#       end

#       # Pictures
#       if record.pictures? and (picture = record.pictures.first)
#         if picture.include? 'url'
#           hash[:meli_pictures] = record.pictures
#         end
#       end

#       # if pictures = record.pictures?
#       #   pictures = pictures
#       # end

#       hash.merge!({
#         description:        description,
#         published_at:       record.start_time,
#         attributes_ajusted: record._attributes?
#       })
#     end


#     def self.update_item_quantity(item_id)
#       @storages = Mercadolibre::Storage.where(meli_item_id: item_id)
#       #Rails.logger.debug " \n\n\n\n\n\n\n\n\n-------------------storages #{@storages}"
#       stores_quantities = []
#       if @storages
#         @storages.each do |storage|
#           store_quantity = storage.l_quantity
#           # Rails.logger.debug " \n\n\n\n\n\n\n\n\n-------------------store_quantity #{store_quantity}"
#           stores_quantities << store_quantity
#           Rails.logger.debug " \n\n\n\n\n\n\n\n\n-------------------stores_quantities #{stores_quantities}"

#         end
#         item_quantity_from_store = stores_quantities.sum
#         @item = Mercadolibre::Item.where(id: item_id).first
#         @item.update(quantity_from_store: item_quantity_from_store)
#       end
#     end

#     def self.attribute_names_sym
#       attribute_names.map {|k| k.gsub(/^_/, "").to_sym }
#     end




















































#     #thiago new item

#     def self.create_or_update_record(meli_item, dashboard, opts = {})

#       raise ArgumentError, "Invalid dashboard element.\n dashboard=`#{dashboard}`." unless dashboard.is_a?(::Dashboard)
#       account   = Account.current || dashboard.account
#       aircrm_item = Mercadolibre::Item.where(meli_item_id: meli_item.id).first_or_initialize

#       #associations
#       #item.user_id                                = dashboard.seller_id
#       aircrm_item.dashboard_id                           = dashboard.id
#       aircrm_item.account_id                             = dashboard.account_id

#       #attrs
#       aircrm_item.buying_mode                            =  meli_item.buying_mode
#       aircrm_item.listing_type_id                        =  meli_item.listing_type_id
#       aircrm_item.status                                 =  meli_item.status
#       aircrm_item.sub_status                             =  meli_item.sub_status.map {|i|i.to_s}
#       aircrm_item.title                                  =  meli_item.title
#       aircrm_item.condition                              =  meli_item.condition
#       aircrm_item.site_id                                =  meli_item.site_id
#       aircrm_item.currency_id                            =  meli_item.currency_id
#       aircrm_item.price                                  =  meli_item.price
#       aircrm_item.base_price                             =  meli_item.base_price
#       aircrm_item.original_price                         =  meli_item.original_price
#       aircrm_item.differential_pricing                   =  meli_item.differential_pricing.serializable_hash if meli_item.differential_pricing != nil

#       aircrm_item.permalink                              =  meli_item.permalink
#       aircrm_item.thumbnail                              =  meli_item.thumbnail
#       aircrm_item.secure_thumbnail                       =  meli_item.secure_thumbnail
#       aircrm_item.meli_pictures                          =  meli_item.pictures.map {|picture| picture.to_s}
#       aircrm_item.video_id                               =  meli_item.video_id
#       aircrm_item.description                            =  meli_item.description.serializable_hash if meli_item.description != nil
#       #item.descriptions                           =  record.descriptions.map {|description| description}
#       #item.attributes_ajusted                     =  record.attributes_ajusted

#       aircrm_item.listing_source                         =  meli_item.listing_source

#       aircrm_item.tags                                   =  meli_item.tags.map {|i| i.to_s}
#       aircrm_item.warranty                               =  meli_item.warranty
#       #aircrm_item.seller_custom_field                    =  meli_item.seller_custom_field
#       aircrm_item.parent_item_id                         =  meli_item.parent_item_id
#       aircrm_item.automatic_relist                       =  meli_item.automatic_relist
#       #item.validation_code                        =  record.validation_code
#       #item.validation_status                      =  record.validation_status
#       #item.validation_errors                      =  record.validation_errors
#       aircrm_item.start_time                             =  meli_item.start_time
#       aircrm_item.stop_time                              =  meli_item.stop_time
#       #aircrm_item.end_time                               =  meli_item.end_time
#       #item.published_at                           =  record.published_at
#       aircrm_item.meli_item_id                           =  meli_item.id
#       aircrm_item.meli_user_id                           =  meli_item.seller_id
#       aircrm_item.category_id                            =  meli_item.category_id
#       aircrm_item.official_store_id                      =  meli_item.official_store_id

#       saved = aircrm_item.save

#       aircrm_item.parse_item_associations aircrm_item, meli_item


#       aircrm_item
#     end

#     def parse_item_associations aircrm_item, meli_item
#       if meli_item.variations
#         parse_item_variations aircrm_item, meli_item
#       end

#       parse_item_storages aircrm_item, meli_item

#       parse_item_infos aircrm_item, meli_item

#       parse_item_pictures aircrm_item, meli_item
#     end


#     def parse_item_variations aircrm_item, meli_item
#       if aircrm_item.variations
#         aircrm_item.variations.destroy_all
#       end
#       meli_item.variations.map do |meli_variation|
#         variation = Mercadolibre::Variation.new
#         variation.item_id                           =   aircrm_item.id
#         variation.price                             =   meli_variation.price?
#         #variation.meli_picture_ids                  =   variation.picture_ids?
#         variation.meli_variation_id                 =   meli_variation.id?
#         variation.seller_custom_field               =   meli_variation.seller_custom_field?
#         variation.save

#         meli_variation.attribute_combinations.map do |meli_variation_type|
#           variation_type                            = Mercadolibre::VariationType.where(meli_value_id: meli_variation_type.value_id?).first_or_initialize
#           variation_type.meli_id                    = meli_variation_type.id?
#           variation_type.meli_name                  = meli_variation_type.name?
#           variation_type.meli_value_id              = meli_variation_type.value_id?
#           variation_type.meli_value_name            = meli_variation_type.value_name?

#           variation_type.save

#           variation_type.variation_to_types.find_or_create_by(variation_id: variation.id, variation_type_id: variation_type.id)
#         end
#       end
#     end

#     def parse_item_storages aircrm_item, meli_item
#         aircrm_item_storage = Mercadolibre::ItemStorage.where(item_id: aircrm_item.id).first_or_initialize

#         aircrm_item_storage.item_id                   =  aircrm_item.id
#         aircrm_item_storage.initial_quantity          =  meli_item.initial_quantity
#         #aircrm_item_storage.unpublished_quantity      =  meli_item.unpublished_quantity
#         unless meli_item.variations.present?
#           aircrm_item_storage.available_quantity        =  meli_item.available_quantity
#           aircrm_item_storage.sold_quantity             =  meli_item.sold_quantity
#           aircrm_item_storage.save
#         else
#           aircrm_item_storage.available_quantity        =  meli_item.variations.map { |variation| variation.available_quantity}.sum
#           aircrm_item_storage.sold_quantity             =  meli_item.variations.map { |variation| variation.sold_quantity}.sum
#         end
#         aircrm_item_storage.save
#     end

#     def parse_item_infos aircrm_item, meli_item
#       aircrm_item_infos = Mercadolibre::MeliInfo.where(item_id: aircrm_item.id).first_or_initialize
#       aircrm_item_infos.accepts_mercadopago               =  meli_item.accepts_mercadopago
#       #aircrm_item_infos.non_mercado_pago_payment_methods  =  meli_item.non_mercado_pago_payment_methods.map {|i|i.to_s}
#       aircrm_item_infos.shipping                          =  meli_item.shipping.serializable_hash if meli_item.shipping != nil
#       #aircrm_item_infos.shipping_options                  =  meli_item.shipping_options
#       aircrm_item_infos.seller_address                    =  meli_item.seller_address.serializable_hash if meli_item.seller_address != nil
#       aircrm_item_infos.seller_contact                    =  meli_item.seller_contact.serializable_hash if meli_item.seller_contact != nil
#       aircrm_item_infos.location                          =  meli_item.location.serializable_hash if meli_item.location != nil
#       aircrm_item_infos.geolocation                       =  meli_item.geolocation.serializable_hash if meli_item.geolocation != nil
#       #aircrm_item_infos.coverage_areas                    =  meli_item.coverage_areas.map {|i|i.to_s}
#       aircrm_item_infos.save
#     end

#     def parse_item_pictures aircrm_item, meli_item
#       meli_item.pictures.each do |meli_picture|
#         aircrm_picture = Mercadolibre::Picture.where(meli_url: meli_picture.url, item_id: aircrm_item.id).first_or_initialize
#         aircrm_picture.meli_id                   = meli_picture.id?
#         aircrm_picture.meli_secure_url           = meli_picture.secure_url?
#         aircrm_picture.meli_size                 = meli_picture.size?
#         aircrm_picture.meli_max_size             = meli_picture.max_size?
#         aircrm_picture.quality                   = meli_picture.quality?
#         #aircrm_name               =
#         #aircrm_url                =
#         aircrm_picture.save
#       end
#     end

#     def serialize_variations
#       variations.map do |variation|
#         variation.serializable_hash(include: [:variation_types])
#       end
#     end

#     def serialize_item
#       serializable_item = serializable_hash
#     end

#     def serialize_info
#       serializable_info = meli_info.serializable_hash
#     end

#     def serialize_storage
#       serializable_storage = item_storage.serializable_hash
#     end

#     def serialize_pictures
#       filter_attributes = ["meli_url"]
#       pictures.map do |picture|
#         old_hash = picture.serializable_hash.slice(*filter_attributes)
#         # old_hash.each do |hash|
#         #   {source: hash.values.first}
#         # end
#       end
#     end




#     def merge_serializables
#       variations_serializable = serialize_variations
#       pictures_serializable = [] << {"source" => serialize_pictures.first.values.first}
#       item_serializable = serialize_item
#       info_serializable = serialize_info
#       storage_serializable = serialize_storage
#       item_serializable.merge!(info_serializable).merge!(storage_serializable).merge!({
#         "variations"=> variations_serializable,
#         "pictures"=> pictures_serializable
#       })
#     end

#     def to_meli #filter_attributes
#       filter_attributes = ["buying_mode", "listing_type_id", "status", "title", "condition",
#                        "site_id", "currency_id", "price", "available_quantity",
#                        "accepts_mercadopago", "non_mercado_pago_payment_methods",
#                        "coverage_areas",
#                       "warranty", "seller_custom_field", "automatic_relist",
#                        "video_id", "category_id", "pictures"]#"variations","seller_address", "location","shipping",
#       merge_serializables.slice(*filter_attributes)
#     end


#     # Import
#     def self.import(file, dashboard)
#       spreadsheet = open_spreadsheet(file)
#       header = spreadsheet.row(1)

#       if header.include?("title")


#         (2..spreadsheet.last_row).each do |i|
#           row = Hash[[header, spreadsheet.row(i)].transpose]
#           puts "----------------------------------------------"
#           puts row.inspect # Array of Excelx::Cell objects
#           puts "----------------------------------------------"
#           item = where(title: row["title"], dashboard_id: dashboard.id).first_or_initialize #|| new
#           #create item_attributes
#           item.status       = :unpublished
#           item.site_id      = "MLB"
#           item.currency_id      = "BRL"
#           item.attributes = row.to_hash.slice(
#                       "buying_mode", "listing_type_id", "title", "condition",
#                       "price", "warranty", "seller_custom_field",
#                       "automatic_relist", "video_id", "category_id")#, "status"

#           item.save!

#           #create item_pictures
#           # row.to_hash.slice("picture1", "picture2", "picture3", "picture4", "picture5", "picture6").each do |picture|
#           #   aircrm_picture = Mercadolibre::Picture.where(aircrm_url: picture, item_id: item.id).first_or_initialize
#           #   aircrm_picture.save
#           # end

#           aircrm_picture = Mercadolibre::Picture.where(item_id: item.id).first_or_initialize
#           aircrm_picture.meli_url =  row.to_hash.slice(*"picture1").to_s
#           aircrm_picture.save

#           #create item_meli_info
#           item_meli_info = Mercadolibre::MeliInfo.where(item_id: item.id).first_or_initialize
#           item_meli_info.accepts_mercadopago                      = row.to_hash.slice("accepts_mercadopago")
#           item_meli_info.non_mercado_pago_payment_methods         = []
#           #item_meli_info.shipping                                 = Mercadolibre::Item.first.meli_info.shipping#"mode" => row.to_hash.slice("shipping_mode")
#           #item_meli_info.seller_address                           = Mercadolibre::Item.first.meli_info.seller_address#dashboard.preferences.seller_address
#           #item_meli_info.location                                 = ActiveSupport::HashWithIndifferentAccess.new
#           item_meli_info.coverage_areas                           = []
#           item_meli_info.save

#           #create item_storage
#           item_storage = Mercadolibre::ItemStorage.where(item_id: item.id).first_or_initialize
#           item_storage.available_quantity = 11 #row.to_hash.slice("available_quantity")
#           item_storage.save


#           record = item.to_meli
#           response = Mercadolibre::Item.api.item_valid? record
#           #publish_response = Mercadolibre::Item.api.create_item record

#           #item.validate_in_meli!
#         end
#       end
#     end

#     def self.open_spreadsheet(file)
#       case File.extname(file.original_filename)
#       when ".csv" then Roo::Csv.new(file.path, { file_warning: :ignore })
#       when ".xls" then Roo::Excel.new(file.path, { file_warning: :ignore })
#       when ".xlsx" then Roo::Excelx.new(file.path, { file_warning: :ignore })
#       else
#         raise "Unknown file type: #{file.original_filename}"
#       end
#     end



#   end
# end


#     # API
#     # a = Mercadolibre::Variation.first.serializable_hash(include: [:variation_types])
#     # b = Mercadolibre::Item.last.serializable_hash(include: [:meli_info, :variations])
#     # c = a.merge(b)
#     # filter_attributes = [:buying_mode, :listing_type_id, :status, :title, :condition,
#                      # :site_id, :currency_id, :price, :available_quantity,
#                      # :accepts_mercadopago, :non_mercado_pago_payment_methods,
#                      # :shipping, :seller_address, :location, :coverage_areas,
#                      # :variations, :warranty, :seller_custom_field, :automatic_relist,
#                      # :video_id]

#     # filter_attributes = ["buying_mode", "listing_type_id", "status", "title", "condition",
#     #                  "site_id", "currency_id", "price", "available_quantity",
#     #                  "accepts_mercadopago", "non_mercado_pago_payment_methods",
#     #                  "shipping", "seller_address", "location", "coverage_areas",
#     #                  "variations", "warranty", "seller_custom_field", "automatic_relist",
#     #                  "video_id"]

# #a.slice!(filter_attributes)

# #item = Mercadolibre::Item.last ; record = item.to_meli;  a = Meli::Item.new record; a.non_mercado_pago_payment_methods = []; a.coverage_areas = [];  a.category_id = "MLB124113" ; Mercadolibre::Item.api.item_valid? a
