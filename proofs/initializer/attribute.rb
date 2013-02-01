require_relative '../proofs_init'

title 'Attribute' 

module Attribute
  module VisibilityMixin
    def hello

    end
  end
  class SomeClass

  end
end
module Initializer
  class Attribute
    module Proof

      def configure_macro
        macro= InitializerMacro.new ::Attribute::SomeClass
        configure macro
        macro
      end

      def added_parameter_to_initializer_macro?(name)
        macro = configure_macro
        macro.parameters.count == 1
      end

      def extended_parameter?
        macro= configure_macro
        macro.parameters[0].is_a? ::Attribute::VisibilityMixin
      end
    end
  end
end

def config
  config = Initializer::Attribute.new(:name, Attribute::VisibilityMixin)
  config
end

heading 'Configuring an initializer macro'
proof 'Adds a new parameter to the initialization macro' do
  config.prove { added_parameter_to_initializer_macro? :name }
end
proof 'Extends the parameter added to the initialization macro with a visibility mixin' do
  config.prove { extended_parameter? }
end
