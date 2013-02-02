module Initializer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    extend self
    def reader(parameter_name)
      Attribute.new parameter_name, Parameter::Visibility::Reader
    end

    def writer(parameter_name)
      Attribute.new parameter_name, Parameter::Visibility::Writer
    end

    def accessor(parameter_name)
      Attribute.new parameter_name, Parameter::Visibility::Accessor
    end

    def no_accessor(parameter_name)
      Attribute.new parameter_name, Parameter::Visibility::NoAccessor
    end

    alias :r :reader
    alias :w :writer
    alias :rw :accessor
    alias :a :accessor
    alias :na :no_accessor

    def initializer(*parameters)
      macro = InitializerMacro.new(self)
      default_visibility = :reader
      
      last_arg = parameters.last
      if last_arg.is_a? Hash 
        parameters.pop
        default_visibility = last_arg[:visibility]
      end

      parameters.each do |parameter|
        attribute = parameter.is_a?(Symbol) ? send(default_visibility, parameter) : parameter
        attribute.configure macro
      end

      macro.define_initializer
    end
  end
end
