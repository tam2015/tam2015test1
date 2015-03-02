class CreateExtensionHstore < ActiveRecord::Migration
  # Dependence:
  #   sudo apt-get install -y postgresql-contrib-9.3
  #   sudo service postgresql restart
  def change
    enable_extension "hstore"
  end
end
