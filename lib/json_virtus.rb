require 'json'

class JsonVirtus < Virtus::Attribute
  def coerce(value)
    value.is_a?(::Hash) ? value : JSON.parse(value)
  end
end
