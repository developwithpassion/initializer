module Initializer
  NO_DEFAULT_VALUE_ALLOWED = Object.new

  def self.included(base)
    base.extend ClassMethods
  end

  class Statement
    def initialize(value)
      @value = value
    end

    def code_fragment
      "#{@value}"
    end
  end

  class StringValue
    def initialize(value)
      @value = value
    end

    def code_fragment
      "'#{@value}'"
    end
  end

  module ClassMethods
    extend self
    

    def initializer_macro(*parameters)
      Macro.generate_definitions self, parameters
    end
    alias :initializer :initializer_macro

    def r(parameter_name, default = NO_DEFAULT_VALUE_ALLOWED)
      return Parameter.build(parameter_name, :reader, default)
    end

    def w(parameter_name, default = NO_DEFAULT_VALUE_ALLOWED)
      return Parameter.build(parameter_name, :writer, default)
    end

    def a(parameter_name, default = NO_DEFAULT_VALUE_ALLOWED)
      return Parameter.build(parameter_name, :accessor, default)
    end
    alias :rw :a

    def na(parameter_name, default = NO_DEFAULT_VALUE_ALLOWED)
      return Parameter.build(parameter_name, :no_accessor, default)
    end

    def statement(code_fragment)
      Statement.new(code_fragment)
    end
  end

end
