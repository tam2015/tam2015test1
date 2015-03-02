module Mercadolibre
  class Storage
    include Provider::ModelBase
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Enum
    include Mongoid::Paranoia

    field :f_codigo
    field :f_descricao
    field :l_quantity, type: Integer
    field :meli_item_id
    field :dashboard_id
    field :user_id

    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)

      if header.include?("f_codigo") && header.include?("f_descricao") && header.include?("l_quantity")


        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          storage = where(:f_codigo => row["f_codigo"].to_s, :f_descricao => row["f_descricao"].to_s ).first_or_initialize #|| new
          storage.attributes = row.to_hash.slice("f_codigo", "f_descricao", "l_quantity")
          storage.save!
          @update_item_quantity = Mercadolibre::Item.update_item_quantity(storage.meli_item_id)
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
