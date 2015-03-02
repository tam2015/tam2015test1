namespace :db do
  desc "Seta um step para todos boxes perdidos"
  task boxes_without_step: :environment do
    step = Step.first
    puts "Setando o Step ##{step.name} para todos boxes perdidos"

    Box.where(step_id: nil).each do |box|
      box.step = step
      box.save
    end
  end

  desc "Cria um subscription para todas as contas que não possuem"
  task account_without_subscription: :environment do
    Account.all.each do |account|
      account.subscription ||= Subscription.create({
        user_id:    account.user_ids.first,
        account_id: account.id,
        status: "trial"
      })
    end
  end

  desc "Adiciona os planos padrões"
  task default_plans: :environment do
    plans = [ {
                name: "bronze",
                price: 39.90
              }, {
                name: "prata",
                price: 69.90
              } ]

    Plan.create(plans)
  end

  desc "Reset account box to re-sync all orders again"
  task reset_accounts: :environment do

    # Statistics before destroy_all
    puts "* Boxes: #{Box.count}"
    ['Shipping', 'Payment', 'Item', 'Customer', 'Feedback', 'Question'].map  do |m|
      puts "* #{m}: #{Object.const_get("Mercadolibre::#{m}").count}"
    end

    # Destroy all Boxes
    Box.destroy_all

    # Destroy all Boxes dependencies
    ['Shipping', 'Payment', 'Item', 'Customer', 'Feedback', 'Question'].map do |m|
      puts Object.const_get("Mercadolibre::#{m}").destroy_all
    end

    puts "* Done."
  end


  desc "Reset a single account to re-sync all orders again"
  task :reset_dashboard, [:dashboard_id] => :environment do |task, args|

    # Dashboard ID
    dashboard_id = args.dashboard_id

    # Box
    Box.where(dashboard_id: dashboard_id).destroy_all

    ['Shipping', 'Payment', 'Item', 'Feedback', 'Question'].map  do |m|
      klass = Object.const_get("Mercadolibre::#{m}")
      klass.where(dashboard_id: dashboard_id).destroy_all
    end

    # Customer
    dashboard = Dashboard.find(dashboard_id)
    dashboard.account.customers.destroy_all
    dashboard.update(synced_at: nil)

    puts "* Done.\n"

    ['Shipping', 'Payment', 'Item', 'Feedback', 'Question'].map  do |m|
      puts "* #{m}: #{Object.const_get("Mercadolibre::#{m}").where(dashboard_id: dashboard_id).count}"
    end

  end




  desc "Sync all accounts again"
  task sync_all_accounts: :environment do
    Dashboard.all.map do |dashboard|
      queue_id = Mercadolibre::AccountSyncWorker.perform_async dashboard.id
      puts "* Enqueing dashboard_id: #{dashboard.id} with AccountSyncWorker. Queue id: #{queue_id}"
    end
  end

end
