module CarrierWave
  IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/pjpeg', 'image/tiff', 'image/x-png']
  FILE_TYPES = ['application/msword', 'application/pdf', 'text/plain', 'text/rtf', 'application/vnd.ms-excel']

  mattr_accessor :image_file_types, :document_file_types
  @@image_file_types = %w(jpg jpeg gif png bmp tif tiff)
  @@document_file_types = %w(pdf doc docx xls xlsx rtf txt)

  module MiniMagick
    # process :strip
    def strip
      manipulate! do |img|
        img.strip
        img = yield(img) if block_given?
        img
      end
    end

    # process quality: 85
    def quality(percentage)
      manipulate! do |img|
        img.auto_orient
        img.strip
        img.interlace "Plane"
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end

    def extract_content_type
      if file.content_type == 'application/octet-stream' || file.content_type.blank?
        content_type = MIME::Types.type_for(original_filename).first
      else
        content_type = file.content_type
      end

      model.data_content_type = content_type.to_s
    end

    def set_size
      model.data_file_size = file.size
    end

    def read_dimensions
      if model.image? && model.has_dimensions?
        magick = ::MiniMagick::Image.new(current_path)
        model.width, model.height = magick[:width], magick[:height]
      end
    end
  end
end
