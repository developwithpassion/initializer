module Initializer
  NO_DEFAULT_VALUE = Object.new

  def self.included(base)
    Extension.! base, ClassMethods
  end

  class Statement
    attr_reader :code_fragment

    def initialize(code_fragment)
      @code_fragment = code_fragment
    end
  end

  module ClassMethods
    extend self
    
    def initializer_macro(*parameters)
      Macro.generate_definitions self, parameters
    end
    alias :initializer :initializer_macro

    def r(parameter_name, default = NO_DEFAULT_VALUE)
      return Parameter.build(parameter_name, :reader, default)
    end

    def w(parameter_name, default = NO_DEFAULT_VALUE)
      return Parameter.build(parameter_name, :writer, default)
    end

    def a(parameter_name, default = NO_DEFAULT_VALUE)
      return Parameter.build(parameter_name, :accessor, default)
    end
    alias :rw :a

    def na(parameter_name, default = NO_DEFAULT_VALUE)
      return Parameter.build(parameter_name, :no_accessor, default)
    end

    def deferred(statement)
      Statement.new(statement)
    end
  end
end
