module Mercadolibre
  class Item < ActiveRecord::Base
    include Provider::ModelBase

    serialize :description

    enum buying_mode: [ :buy_it_now, :auction, :classified ]#, default: :buy_it_now

    enum listing_type_id: [ :gold_special, :gold_premium, :gold, :silver, :bronze, :free ]#, default: :free

    enum status: [ :empty, :unpublished, :invalid_data, :not_yet_active, :payment_required, :paused, :active, :closed, :under_review, :inactive ]

    CONDITIONS = %w(new used not_specified)

    #attr_accessor :category, :youtube_url

    ### Aliases
    alias_attribute :seller_id, :meli_user_id
    alias_attribute :date_created, :created_at
    alias_attribute :last_updated, :updated_at


    # mount_uploaders :pictures_uploaded, ImageUploader
    has_many :variations
    has_one :item_storage
    has_one :meli_info
    has_many :pictures

    ### Validations
    # 1. Para anunciar em Diamante é necessesário adicionar fotos.

    # validates :title, :category_id,
    #   # Validate associations
    #   :account_id#, :user_id,
    #   # Role
    #   presence: { unless: lambda { self.new_record? } }

    # Virtual Attribute
    def category
      if category_id?
        if defined?(@category) and category_id == @category.id
          @category
        else
          @category = ::Meli::Category.find(category_id)
        end
      end
    end

    def category=(record)
      if record.kind_of? ::Meli::Category
        category_id = record.id
        @category   = record
      end
    end

    def category?
      !!category_id
    end

    def youtube_url
      if @youtube_url.nil? and self.video_id?
        @youtube_url = "http://www.youtube.com/watch?v=#{self.video_id}"
      end
      @youtube_url
    end

    # Export
    def as_json(options = nil)
      options = {
                  include: {
                    pictures: {
                      methods: [ :size, :content_type ]
                    }
                  }
                }.merge(options || {})

      hash = super(options)

      hash.delete("descriptions")

      unless category.nil?
        hash[:category] = category.serializable_hash
      end

      hash.merge({
        "status"          => hash.delete("_status"         ),
        "buying_mode"     => hash.delete("_buying_mode"    ),
        "listing_type_id" => hash.delete("_listing_type_id")
        })
    end

    def self.update_item_quantity(item_id)
      @storages = Mercadolibre::Storage.where(meli_item_id: item_id)
      #Rails.logger.debug " \n\n\n\n\n\n\n\n\n-------------------storages #{@storages}"
      stores_quantities = []
      if @storages
        @storages.each do |storage|
          store_quantity = storage.l_quantity
          # Rails.logger.debug " \n\n\n\n\n\n\n\n\n-------------------store_quantity #{store_quantity}"
          stores_quantities << store_quantity
          Rails.logger.debug " \n\n\n\n\n\n\n\n\n-------------------stores_quantities #{stores_quantities}"

        end
        item_quantity_from_store = stores_quantities.sum
        @item = Mercadolibre::Item.where(id: item_id).first
        @item.update(quantity_from_store: item_quantity_from_store)
      end
    end

    def self.attribute_names_sym
      attribute_names.map {|k| k.gsub(/^_/, "").to_sym }
    end

    #thiago new item

    def self.create_or_update_record(meli_item, dashboard, opts = {})
      #attr that are not being used to parse_item
      #item.user_id                                = dashboard.seller_id
      #aircrm_item.description                     =  meli_item.description.serializable_hash if meli_item.description != nil
      #item.descriptions                           =  record.descriptions.map {|description| description}
      #item.attributes_ajusted                     =  record.attributes_ajusted
      #aircrm_item.seller_custom_field             =  meli_item.seller_custom_field
      #item.validation_code                        =  record.validation_code
      #item.validation_status                      =  record.validation_status
      #item.validation_errors                      =  record.validation_errors
      #aircrm_item.end_time                        =  meli_item.end_time
      #item.published_at                           =  record.published_at

      raise ArgumentError, "Invalid dashboard element.\n dashboard=`#{dashboard}`." unless dashboard.is_a?(::Dashboard)
      account   = Account.current || dashboard.account
      aircrm_item = Mercadolibre::Item.where(meli_item_id: meli_item.id).first_or_initialize

      #associations
      aircrm_item.dashboard_id                           = dashboard.id
      aircrm_item.account_id                             = dashboard.account_id

      #attrs
      aircrm_item.buying_mode                            =  meli_item.buying_mode
      aircrm_item.listing_type_id                        =  meli_item.listing_type_id
      aircrm_item.status                                 =  meli_item.status
      aircrm_item.title                                  =  meli_item.title
#      aircrm_item.description                            =  meli_item.description.text
      aircrm_item.condition                              =  meli_item.condition
      aircrm_item.price                                  =  meli_item.price
      aircrm_item.base_price                             =  meli_item.base_price
      aircrm_item.video_id                               =  meli_item.video_id
      aircrm_item.warranty                               =  meli_item.warranty
      aircrm_item.automatic_relist                       =  meli_item.automatic_relist
      aircrm_item.meli_item_id                           =  meli_item.id
      aircrm_item.category_id                            =  meli_item.category_id
      aircrm_item.official_store_id                      =  meli_item.official_store_id

      saved = aircrm_item.save

      aircrm_item.parse_item_associations aircrm_item, meli_item


      aircrm_item
    end

    def parse_item_associations aircrm_item, meli_item
      if meli_item.variations
        parse_item_variations aircrm_item, meli_item
      end

      parse_item_storages aircrm_item, meli_item

      parse_item_infos aircrm_item, meli_item

      parse_item_pictures aircrm_item, meli_item
    end


    def parse_item_variations aircrm_item, meli_item
      if aircrm_item.variations
        aircrm_item.variations.destroy_all
      end
      meli_item.variations.map do |meli_variation|
        variation = Mercadolibre::Variation.new
        variation.item_id                           =   aircrm_item.id
        variation.price                             =   meli_variation.price?
        #variation.meli_picture_ids                  =   variation.picture_ids?
        variation.meli_variation_id                 =   meli_variation.id?
        variation.seller_custom_field               =   meli_variation.seller_custom_field?
        variation.save

        meli_variation.attribute_combinations.map do |meli_variation_type|
          variation_type                            = Mercadolibre::VariationType.where(meli_value_id: meli_variation_type.value_id?).first_or_initialize
          variation_type.meli_id                    = meli_variation_type.id?
          variation_type.meli_name                  = meli_variation_type.name?
          variation_type.meli_value_id              = meli_variation_type.value_id?
          variation_type.meli_value_name            = meli_variation_type.value_name?

          variation_type.save

          variation_type.variation_to_types.find_or_create_by(variation_id: variation.id, variation_type_id: variation_type.id)
        end
      end
    end

    def parse_item_storages aircrm_item, meli_item
        aircrm_item_storage = Mercadolibre::ItemStorage.where(item_id: aircrm_item.id).first_or_initialize

        aircrm_item_storage.item_id                   =  aircrm_item.id
        aircrm_item_storage.initial_quantity          =  meli_item.initial_quantity
        #aircrm_item_storage.unpublished_quantity      =  meli_item.unpublished_quantity
        unless meli_item.variations.present?
          aircrm_item_storage.available_quantity        =  meli_item.available_quantity
          aircrm_item_storage.sold_quantity             =  meli_item.sold_quantity
          aircrm_item_storage.save
        else
          aircrm_item_storage.available_quantity        =  meli_item.variations.map { |variation| variation.available_quantity}.sum
          aircrm_item_storage.sold_quantity             =  meli_item.variations.map { |variation| variation.sold_quantity}.sum
        end
        aircrm_item_storage.save
    end


    def parse_item_infos aircrm_item, meli_item
      aircrm_item_infos = Mercadolibre::MeliInfo.where(item_id: aircrm_item.id).first_or_initialize

      aircrm_item_infos.accepts_mercadopago               =  meli_item.accepts_mercadopago
      aircrm_item_infos.non_mercado_pago_payment_methods  =  meli_item.non_mercado_pago_payment_methods.to_json
      aircrm_item_infos.shipping                          =  meli_item.shipping if meli_item.shipping != nil
      aircrm_item_infos.seller_address                    =  meli_item.seller_address if meli_item.seller_address != nil
      aircrm_item_infos.geolocation                       =  meli_item.geolocation
      aircrm_item_infos.site_id                           =  meli_item.site_id
      aircrm_item_infos.currency_id                       =  meli_item.currency_id
      aircrm_item_infos.permalink                         =  meli_item.permalink
      aircrm_item_infos.thumbnail                         =  meli_item.thumbnail
      aircrm_item_infos.secure_thumbnail                  =  meli_item.secure_thumbnail
      aircrm_item_infos.meli_start_time                   =  meli_item.start_time
      aircrm_item_infos.meli_stop_time                    =  meli_item.stop_time
      aircrm_item_infos.meli_end_time                     =  meli_item.end_time
      aircrm_item_infos.meli_last_updated                 =  meli_item.last_updated

      aircrm_item_infos.save
    end

    def parse_item_pictures aircrm_item, meli_item
      meli_item.pictures.each do |meli_picture|
        aircrm_picture = Mercadolibre::Picture.where(meli_url: meli_picture.url, item_id: aircrm_item.id).first_or_initialize
        aircrm_picture.meli_id                   = meli_picture.id if meli_picture.id
        aircrm_picture.meli_secure_url           = meli_picture.secure_url if meli_picture.secure_url
        aircrm_picture.meli_size                 = meli_picture.size if meli_picture.size
        aircrm_picture.meli_max_size             = meli_picture.max_size if meli_picture.max_size
        aircrm_picture.quality                   = meli_picture.quality if meli_picture.quality

        aircrm_picture.save
      end
    end

    def serialize_variations
      variations.map do |variation|
        variation.serializable_hash(include: [:variation_types])
      end
    end

    def serialize_item
      serializable_item = serializable_hash
    end

    def serialize_info
      non_mercado_pago_payment_methods = meli_info.non_mercado_pago_payment_methods
      non_mercado_pago_payment_methods_to_hash = JSON.parse non_mercado_pago_payment_methods
      meli_info.non_mercado_pago_payment_methods = non_mercado_pago_payment_methods_to_hash
      serializable_info = meli_info.serializable_hash
    end

    def serialize_storage
      serializable_storage = item_storage.serializable_hash
    end

    def serialize_pictures
      filter_attributes = ["source"]
      pictures.map do |picture|
        old_hash = picture.serializable_hash.slice(*filter_attributes)
        # old_hash.each do |hash|
        #   {source: hash.values.first}
        # end
      end
    end

    def merge_serializables
      variations_serializable = serialize_variations
      pictures_serializable = serialize_pictures
      item_serializable = serialize_item
      info_serializable = serialize_info
      storage_serializable = serialize_storage
      item_serializable.merge!(info_serializable).merge!(storage_serializable).merge!({
        "variations"=> variations_serializable,
        "pictures"=> pictures_serializable
      })
    end

    def to_meli #filter_attributes
      filter_attributes = ["buying_mode", "listing_type_id", "status", "title", "condition",
                       "site_id", "currency_id", "price", "available_quantity",
                       "accepts_mercadopago", "non_mercado_pago_payment_methods",
                      "warranty", "seller_custom_field", "automatic_relist",
                       "video_id", "category_id", "pictures", "shipping"]#"variations","seller_address", "location",
      merge_serializables.slice(*filter_attributes)
    end


    # Import
    def self.import(file, dashboard)
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)

      if header.include?("title")


        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          item = where(title: row["title"], dashboard_id: dashboard.id).first_or_initialize

          #create item_attributes
          item.status       = :unpublished
          item.attributes = row.to_hash.slice(
                      "buying_mode", "listing_type_id", "title", "condition",
                      "description", "price", "warranty", "seller_custom_field",
                      "automatic_relist", "video_id", "category_id")#, "status"

          item.save!

          #create item_pictures
          aircrm_picture1 = Mercadolibre::Picture.where(source: row["picture1"], item_id: item.id).first_or_initialize
          aircrm_picture1.save if row["picture1"] != nil
          aircrm_picture2 = Mercadolibre::Picture.where(source: row["picture2"], item_id: item.id).first_or_initialize
          aircrm_picture2.save if row["picture2"] != nil
          aircrm_picture3 = Mercadolibre::Picture.where(source: row["picture3"], item_id: item.id).first_or_initialize
          aircrm_picture3.save if row["picture3"] != nil
          aircrm_picture4 = Mercadolibre::Picture.where(source: row["picture4"], item_id: item.id).first_or_initialize
          aircrm_picture4.save if row["picture4"] != nil
          aircrm_picture5 = Mercadolibre::Picture.where(source: row["picture5"], item_id: item.id).first_or_initialize
          aircrm_picture5.save if row["picture5"] != nil
          aircrm_picture6 = Mercadolibre::Picture.where(source: row["picture6"], item_id: item.id).first_or_initialize
          aircrm_picture6.save if row["picture6"] != nil

          # it did not work because did not save the item_id inside the block
          # [row["picture1"], row["picture2"], row["picture3"], row["picture4"], row["picture5"], row["picture6"]].each do |picture|
          #   aircrm_picture = Mercadolibre::Picture.new
          #   aircrm_picture.meli_url =  picture
          #   item_id                 =  item.id
          #   aircrm_picture.save
          # end



          #create item_meli_info
          dimension = row["dimension"]
          item_meli_info = Mercadolibre::MeliInfo.where(item_id: item.id).first_or_initialize
          item_meli_info.accepts_mercadopago                      = true if row["accepts_mercadopago"] == "sim"
          item_meli_info.non_mercado_pago_payment_methods         = [{"id"=>"MLBMO", "description"=>"Dinheiro", "type"=>"G"}, {"id"=>"MLBCC", "description"=>"Cartão de Crédito", "type"=>"N"}, {"id"=>"MLBDE", "description"=>"Depósito Bancário", "type"=>"D"}].to_json if row["non_mercado_pago_payment_methods"] == "sim" #and item.price < 200
          item_meli_info.shipping                                 = {"mode"=>"me2", "local_pick_up"=>true, "free_shipping"=>false, "methods"=>[], "dimensions"=>dimension} if  dashboard.preferences.shipping_modes.include?("me2") and  row["me2"] == "sim"
          item_meli_info.shipping                                 = {"mode"=>"me1", "local_pick_up"=>true, "free_shipping"=>false, "methods"=>[], "dimensions"=>dimension} if  dashboard.preferences.shipping_modes.include?("me1") and  row["me1"] == "sim"
          item_meli_info.site_id                                  = "MLB"
          item_meli_info.currency_id                              = "BRL"
          item_meli_info.save

          #create item_storage
          item_storage = Mercadolibre::ItemStorage.where(item_id: item.id).first_or_initialize
          item_storage.available_quantity = row["available_quantity"]
          item_storage.save


          #if item.new_record?
            record = item.to_meli
            response = Mercadolibre::Item.api.item_valid? record
            meli_item_responsed = Mercadolibre::Item.api.create_item record
            item.update(
              meli_item_id:  meli_item_responsed.id
              )
            # item.meli_info.update(
            #   non_mercado_pago_payment_methods: meli_item_responsed.non_mercado_pago_payment_methods.to_json,
            #   shipping: meli_item_responsed.shipping
            #   )
            self.create_or_update_record(meli_item_responsed, dashboard, opts = {})
          # end


          #item.validate_in_meli!
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



  end
end


    # API
    # a = Mercadolibre::Variation.first.serializable_hash(include: [:variation_types])
    # b = Mercadolibre::Item.last.serializable_hash(include: [:meli_info, :variations])
    # c = a.merge(b)
    # filter_attributes = [:buying_mode, :listing_type_id, :status, :title, :condition,
                     # :site_id, :currency_id, :price, :available_quantity,
                     # :accepts_mercadopago, :non_mercado_pago_payment_methods,
                     # :shipping, :seller_address, :location, :coverage_areas,
                     # :variations, :warranty, :seller_custom_field, :automatic_relist,
                     # :video_id]

    # filter_attributes = ["buying_mode", "listing_type_id", "status", "title", "condition",
    #                  "site_id", "currency_id", "price", "available_quantity",
    #                  "accepts_mercadopago", "non_mercado_pago_payment_methods",
    #                  "shipping", "seller_address", "location", "coverage_areas",
    #                  "variations", "warranty", "seller_custom_field", "automatic_relist",
    #                  "video_id"]

#a.slice!(filter_attributes)

#item = Mercadolibre::Item.last ; record = item.to_meli;  a = Meli::Item.new record; a.non_mercado_pago_payment_methods = []; a.coverage_areas = [];  a.category_id = "MLB124113" ; Mercadolibre::Item.api.item_valid? a


#no momento q publicar já salvar o status como activating
#fazer um job para atualizar as pictures e o status do item
##criar duas tabelas para pictures, uma com aircrm_pictures e outra com meli_pictures
#identificar no meli se item publicado já não existe


