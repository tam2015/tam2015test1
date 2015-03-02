# == Schema Information
#
# Table name: dashboards
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  provider         :string(255)
#  uid              :string(255)
#  token            :string(255)
#  refresh_token    :string(255)
#  token_expires_at :string(255)
#  account_id       :integer
#  created_at       :datetime
#  updated_at       :datetime
#

module Mercadolibre
  module Dashboard
    module ClassMethods

      def provided_by
        :mercadolibre
      end

    end

    module InstanceMethods
      def provider_after_create(user)
        # Workers::BoxWorker.perform_async(id)
        #ItemWorker.perform_async uid
      end
    end

  end
end
