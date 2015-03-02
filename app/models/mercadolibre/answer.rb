module Mercadolibre
  class Answer
    def self.attr_list
      [:text, :status, :date_created]
    end

    attr_reader *attr_list
    attr_writer *attr_list


    def initialize(attributes={})
      (attributes || {}).each do |k, v|
        if k.to_s == 'date_created'
          self.date_created = Time.parse(v)
        else
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end
    end

    # Converts an object of this instance into a database friendly value.
    def mongoize
      JSON.parse self.to_json
    end

    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def self.demongoize(attributes)
      Answer.new(attributes)
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def self.mongoize(attributes)
      case attributes
      when Answer then attributes.mongoize
      when Hash then Answer.new(attributes).mongoize
      else attributes
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def self.evolve(object)
      case object
      when Answer then object.mongoize
      else object
      end
    end
  end
end
