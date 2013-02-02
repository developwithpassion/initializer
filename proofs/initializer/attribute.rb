require_relative '../proofs_init'

title 'Attribute' 

module AttributeExamples
  module SomeVisibility
  end

  class SomeTargetClass
  end
end

module Initializer
  class Parameter
    module Proof
      def extended?
        self.is_a? ::AttributeExamples::SomeVisibility
      end
    end
  end
end

def attribute
  attribute = Initializer::Attribute.new(:some_parameter_name, AttributeExamples::SomeVisibility)
  attribute
end

heading 'Configuring an initializer macro'

proof 'Adds a new parameter to the initialization macro' do
  macro = Initializer::InitializerMacro.new ::AttributeExamples::SomeTargetClass
  parameter = attribute.configure macro
  parameter.prove { extended? }
end
