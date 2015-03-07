namespace :rubber do
  #namespace :config do
  namespace :configuration do

    rubber.allow_optional_tasks(self)

    desc <<-DESC
      Add executaple permission to scripts in current_path
    DESC

    after "deploy:create_symlink", "rubber:configuration:update_permission_scripts"
    task :update_permission_scripts do
      rsudo "chmod +x -R #{current_path}/script"
    end

    desc <<-DESC
      Add executaple permission to scripts in release_path
    DESC

    after "deploy:finalize_update", "rubber:configuration:update_permission_scripts_release"
    task :update_permission_scripts_release do
      rsudo "chmod +x -R #{release_path}/script"
    end
  end
end
