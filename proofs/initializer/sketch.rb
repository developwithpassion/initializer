require 'test/unit/assertions'
include Test::Unit::Assertions

module Initializer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def initializer(*parameters)
      macro = Macro.build self, parameters
      macro.generate_definitions
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

      normalize(parameters, options.visibility)
      new target_class, parameters
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

    def self.normalize(parameters, default_visibility)
      parameters.map! do |p|
        normalize_parameter(p, default_visibility)
      end
    end

    def self.normalize_parameter(parameter, default_visibility)
      if parameter.is_a? Symbol
        return Parameter.new parameter, default_visibility
      else
        return parameter
      end
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
