namespace :app do
  desc "Lista todos usuários com seus respectivos emails e numero de boxes"
  task users: :environment do
    @users = User.all.each do |user|
      puts "##{user.id} #{user.name} <#{user.email}>;"
    end

    puts "\n\n #{@users.count} usuários registrados."
  end

  # desc "Lista todos usuários com seus respectivos emails e numero de boxes"
  # task users_with_boxes: :environment do
  #   User.all.each do |u|
  #   end
  # end
end
