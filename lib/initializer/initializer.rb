module Initializer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    extend self
    def initializer(*parameters)
      Macro.generate_definitions self, parameters
    end

    def r(parameter_name)
      return Parameter.new(parameter_name, :reader)
    end

    def w(parameter_name)
      return Parameter.new(parameter_name, :writer)
    end

    def a(parameter_name)
      return Parameter.new(parameter_name, :accessor)
    end

    def na(parameter_name)
      return Parameter.new(parameter_name, :no_accessor)
    end
  end

end
