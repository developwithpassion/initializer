require 'test/unit/assertions'
include Test::Unit::Assertions

module Initializer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
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

  class Parameter
    attr_reader :name    
    attr_reader :visibility    

    def initialize(name, visibility)
      @name = name
      @visibility = visibility
    end
  end

  module InitializerOptions
    def visibility
      self[:default]
    end
  end

  class Macro
    DEFAULT_VISIBILITY = :reader

    attr_reader :target_class
    attr_reader :parameters

    def initialize(target_class, parameters)
      @target_class = target_class
      @parameters = parameters
    end

    def self.build(target_class, parameters)
      parameters, options = separate_parameters(parameters)
      options.extend InitializerOptions
      parameters = NormalizeParameters.normalize(parameters, options.visibility)
      instance = new target_class, parameters
      instance
    end

    def self.generate_definitions(target_class, parameters)
      instance = build target_class, parameters
      instance.generate_definitions
    end

    def self.separate_parameters(parameters)
      if options?(parameters)
        options = parameters.pop
      else
        options = { :default => DEFAULT_VISIBILITY }
      end

      return parameters, options
    end

    def self.options?(parameters)
      parameters.last.is_a? Hash
    end

    def generate_definitions
      define_attributes
      ## TODO define_initializer
      ## pattern suggests there will be an Initializer class (ie: because there's Attribute class)
    end

    def define_attributes
      parameters.each do |p|
        Attribute.define target_class, p.name, p.visibility
      end
    end
  end

  class NormalizeParameters
    attr_reader :parameters
    attr_reader :default_visibility

    def initialize(parameters, default_visibility)
      @parameters = parameters
      @default_visibility = default_visibility
    end

    def self.normalize(parameters, default_visibility)
      instance = new parameters, default_visibility
      instance.normalize
      instance.parameters
    end

    def normalize
      @parameters = parameters.map do |p|
        normalize_parameter p
      end
    end

    def normalize_parameter(parameter)
      if parameter.is_a? Symbol
        return Parameter.new parameter, default_visibility
      else
        return parameter
      end
    end
  end

  class Attribute
    attr_reader :target_class
    attr_reader :name
    attr_reader :visibility

    def initialize(target_class, name, visibility)
      @target_class = target_class
      @name = name
      @visibility = visibility
    end

    def self.define(target_class, name, visibility)
      instance = new target_class, name, visibility
      instance.define
    end

    def define
      define_getter if [:reader, :accessor].include? visibility
      define_setter if [:writer, :accessor].include? visibility
    end

    def define_getter
      target_class.send :define_method, name do
        instance_variable_get("@#{name}")
      end
    end

    def define_setter
      target_class.send :define_method, "#{name}=" do |value|
        instance_variable_set("@#{name}", value)
      end
    end
  end
end

class SomeTargetClass
  include Initializer

  initializer :foo, a(:bar), w(:baz), na(:qux), r(:fred)
end

something = SomeTargetClass.new

assert something.respond_to?(:foo), "Has getter"
assert !something.respond_to?(:foo=), "Has setter"

assert something.respond_to?(:bar), "Has getter"
assert something.respond_to?(:bar=), "Has setter"

assert !something.respond_to?(:baz), "Has getter"
assert something.respond_to?(:baz=), "Has setter"

assert !something.respond_to?(:qux), "Has getter"
assert !something.respond_to?(:qux=), "Has setter"

assert something.respond_to?(:fred), "Has getter"
assert !something.respond_to?(:fred=), "Has setter"

class SomeTargetClassWithDefaultVisibility
  include Initializer

  initializer :foo, :default => :accessor
end

something = SomeTargetClassWithDefaultVisibility.new

assert something.respond_to?(:foo), "Has getter"
assert something.respond_to?(:foo=), "Has setter"
