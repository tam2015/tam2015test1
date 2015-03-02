class NotifyAgent < ActiveRecord::Base


  # Validations
  #validates :name, :meli_user_id, :type, presence: true

  # Validate presence of field only if another field is blank
  # validates :email, presence: { unless: -> { phone? } }
  # validates :phone, presence: { unless: -> { email? } }

  def name
    [first_name, last_name].join("\s")
  end

  def self.attribute_names_sym
    fields.keys.map {|k| k.gsub(/^_/, "").to_sym }
  end

end
