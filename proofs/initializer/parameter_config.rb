require_relative '../proofs_init'

title 'Parameter Config' 

module ParameterConfig
  module SomeModule
    def hello

    end
  end
  class SomeClass

  end
end
module Initializer
  class ParameterConfig
    module Proof
      def added_parameter_to_initializer_macro?(name)
        macro= InitializerMacro.new ::ParameterConfig::SomeClass
        configure macro
        macro.parameters.count == 1
      end
      def extended_parameter?
        macro= InitializerMacro.new ::ParameterConfig::SomeClass
        configure macro
        macro.parameters[0].is_a? ::ParameterConfig::SomeModule
      end
    end
  end
end

def config
  config = Initializer::ParameterConfig.new(:name, ParameterConfig::SomeModule)
  config
end

heading 'Configuring an initializer macro'
proof 'Adds a new parameter to the initialization macro' do
  config.prove { added_parameter_to_initializer_macro? :name }
end
proof 'Extends the parameter added to the initialization macro with its mixin' do
  config.prove { extended_parameter? }
end
