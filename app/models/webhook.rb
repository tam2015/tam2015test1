class Webhook

  attr_accessor :provider, :data, :hook

  AVAILABLE_PROVIDERS = %W(mercadolibre)

  def self.providers
    AVAILABLE_PROVIDERS
  end

  def initialize(provider, notification)
    raise ArgumentError, "Provider Missing" if provider.nil?

    @provider = provider.to_s
    @data = notification
    return unless AVAILABLE_PROVIDERS.include?(@provider)
  end

  def hook_class_name
    name  = @provider.to_s.capitalize
    topic = hook_topic.to_s.capitalize
    Object.const_get("#{name}::Hooks::#{topic}")
  end

  def provider
    @provider.to_sym
  end

  def instantiate_topic_class
    return if hook_class.nil?
    @hook = hook_class.new data
  end

  def hook_topic
    data[:topic]
  end

  def hook_class
    begin
      hook_class_name
    rescue NameError => e
      nil
    end
  end
end
