module Initializer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def no_accessors(parameter_name)
      ParameterConfig.new parameter_name, NoAccessorsParameter
    end

    def reader(parameter_name)
      ParameterConfig.new parameter_name, ReaderParameter
    end

    def writer(parameter_name)
      ParameterConfig.new parameter_name, WriterParameter
    end

    def accessor(parameter_name)
      ParameterConfig.new parameter_name, AccessorParameter
    end

    alias :r :reader
    alias :w :writer
    alias :rw :accessor
    alias :a :accessor

    def initializer(*parameters)
      macro = InitializerMacro.new(self)
      last_arg = parameters.last
      default_visibility = :reader

      if last_arg.is_a? Hash 
        parameters.pop
        default_visibility = last_arg[:visibility]
      end


      parameters.each do |parameter|
        parameter_configuration = parameter.is_a?(Symbol) ? send(default_visibility, parameter) : parameter
        parameter_configuration.configure macro
      end

      macro.define_initializer
    end
  end
end
