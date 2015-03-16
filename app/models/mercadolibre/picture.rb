module Mercadolibre
  class Picture < ActiveRecord::Base
    belongs_to :item

    mount_uploader :cwave, CwaveUploader

  end
end
