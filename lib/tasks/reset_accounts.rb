namespace :db
  desc "Reset account box to re-sync all orders again"
  task reset_accounts: :environment do

    # Statistics before destroy_all
    puts "* Boxes: #{Box.count}"
    ['Shipping', 'Payment', 'Item', 'Customer', 'Feedback'].map  do |m|
      puts "* #{m}: #{Object.const_get("Mercadolibre::#{m}").count}"
    }

    # Destroy all Boxes
    Box.destroy_all

    # Destroy all Boxes dependencies
    ['Shipping', 'Payment', 'Item', 'Customer', 'Feedback'].map do |m|
      puts Object.const_get("Mercadolibre::#{m}").destroy_all
    }

    puts "* Done."
  end
end
