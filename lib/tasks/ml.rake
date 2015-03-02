namespace :ml do
  desc "Cria os steps padrões para todos os usuários"
  task default_steps: :environment do
    Providers.load_models :mercadolibre

    Dashboard.where(provider: "mercadolibre").all.each do |dashboard|
      user = dashboard.users.first

      args = {
        credentials: {
         token:            dashboard.token,
         refresh_token:    dashboard.refresh_token,
         token_expires_at: dashboard.token_expires_at
       }
      }

      provider = Providers.load_provider(dashboard.provider, args)

      steps = Step.create_default({
                    user:       user,
                    dashboard:  dashboard
                    })
    end
  end
end
