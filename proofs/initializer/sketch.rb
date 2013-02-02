require 'test/unit/assertions'
include Test::Unit::Assertions

module Initializer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def initializer(*parameters)
      macro = Macro.build self, parameters
      macro.define_attributes
    end

    def rw(parameter_name)
      return Parameter.new(parameter_name, :accessor)
    end
  end

  class Parameter
    attr_reader :name    

    def initialize(name, visibility_name)
      @name = name
      @visibility_name = visibility_name
    end
  end

  class Macro
    attr_reader :target_class
    attr_reader :parameters

    def initialize(target_class, parameters)
      @target_class = target_class
      @parameters = parameters
    end

    def self.build(target_class, parameters)
      normalize parameters
      new target_class, parameters
    end

    def self.normalize(parameters)
      parameters.map! do |p|
        normalize_parameter p
      end
    end

    def self.normalize_parameter(parameter)
      if parameter.is_a? Symbol
        return Parameter.new parameter, :reader
      else
        return parameter
      end
    end

    def define_attributes
      parameters.each do |p|
        define_attribute p
      end
    end

    def define_attribute(parameter)
      define_getter parameter.name
      define_setter parameter.name
    end

    def define_getter(name)
      target_class.send :define_method, name do
        instance_variable_get("@#{name}")
      end
    end

    def define_setter(name)
      target_class.send :define_method, "#{name}=" do |value|
        instance_variable_set("@#{name}", value)
      end
    end
  end
end

class SomeTargetClass
  include Initializer

  initializer(:foo, rw(:bar), :baz)  
end

something = SomeTargetClass.new

assert something.respond_to?(:foo), "Has getter"
assert something.respond_to?(:foo=), "Has setter"

