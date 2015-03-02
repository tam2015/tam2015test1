module Providers
  MODELS = [
    "Dashboard"
  ]
  MODELS_LOAD_INCREMENT = [
    # Exclusive models Mercado Libre
    "::Mercadolibre::Question",
    "::Mercadolibre::Shipping"
  ]

  def self.inner_provider(provider_name, receiver)
    provider_name.capitalize!
    if Providers.const_defined? provider_name
      provider = "::#{provider_name}".constantize
      receiver = receiver.constantize

      if provider.const_defined? receiver.name
        receiver_const = "#{provider.name}::#{receiver.name}"

        receiver.extend         "#{receiver_const}::ClassMethods".constantize
        receiver.send :include, "#{receiver_const}::InstanceMethods".constantize
      end
    else
      nil
    end
  end

  def self.load_models provider_name
    MODELS.map do |mod|
      inner_provider(provider_name, mod )
    end
  end

  def self.load_provider provider_name, options={}
    provider_name.capitalize!
    if Providers.const_defined? provider_name
      provider = "Providers::#{provider_name}::Api".constantize.new options

      [MODELS, MODELS_LOAD_INCREMENT].flatten.map do |mod|
        mod.constantize.send :provider=, provider
      end

      provider
    end
  end

end
