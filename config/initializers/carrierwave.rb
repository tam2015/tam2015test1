CarrierWave.configure do |config|
  # Save images in DB
  # config.storage :grid_fs
  # config.grid_fs_access_url = "/storage"

  # Save imagens in file
  config.storage :file
  config.cache_dir          = "#{Rails.root}/tmp/uploads"

  # config.root = Rails.root.join('tmp')


  if Rails.env.production? and defined?(ENV["AWS_ACCESS_KEY_ID"])
    config.storage :fog

    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key:  ENV["AWS_SECRET_KEY"],
      region:                 ENV["AWS_REGION"] || 'us-west-1',
      host:                   ENV["AWS_HOST"] || 's3.amazonaws.com'
    }
    config.fog_directory  = ENV["AWS_BUCKET"]
    # config.fog_public     = false
    # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
    # config.cache_dir      = "#{Rails.root}/tmp/uploads"
  end
end
