# class ImageUploader < CarrierWave::Uploader::Base
#   include CarrierWave::MiniMagick

#   # Override the directory where uploaded files will be stored.
#   # This is a sensible default for uploaders that are meant to be mounted:
#   def store_dir
#     # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
#     "#{model.class.to_s.underscore}/#{mounted_as}"
#   end

#   # Provide a default URL as a default if there hasn't been a file uploaded:
#   def default_url
#     # For Rails 3.1+ asset pipeline compatibility:
#     ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default-image.jpg"].compact.join('_'))
#   end

#   # Process files as they are uploaded:
#   process :read_dimensions
#   # process quality: 85

#   version :thumb do
#     process convert: "jpg"
#     process resize_to_fill: [256, 256]
#   end

#   version :mini, from_version: :thumb do
#     process resize_to_fill: [36, 36]
#   end


#   # Add a white list of extensions which are allowed to be uploaded.
#   # For images you might use something like this:
#   def extension_white_list
#     CarrierWave.image_file_types
#   end

#   # Override the filename of the uploaded files:
#   # Avoid using model.id or version_name here, see uploader/store.rb for details.
#   def filename
#     "#{model.id}.jpg"
#   end

#   module Asset
#     include Rails.application.routes.url_helpers

#     def has_dimensions?
#       respond_to?(:width) && respond_to?(:height)
#     end

#     def image?
#       CarrierWave::IMAGE_TYPES.include?(data_content_type)
#     end

#     def image
#       url
#     end

#     def full_url
#       "http://#{ENV['HOST']}#{url}"
#     end

#     def thumb
#       url(:thumb)
#     end

#     def as_json_methods
#       [:image, :thumb]
#     end

#     def as_json(options = nil)
#       options = {
#         methods: as_json_methods,
#         root: false
#       }

#       super options
#     end
#   end
# end
