require_relative '../proofs_init'

title 'Reader Parameter' 

module ReaderParameter
  class SomeClass
  end

  class SomeParameter
    include Initializer::Parameter::Visibility::Reader

    def name
      :name
    end

    module Proof
      def generates_attr_reader?
        attr_defined?
      end

      def attr_defined?(name)
        SomeClass.method_defined?(:name)
      end
    end
  end
end

def parameter
  parameter = ReaderParameter::SomeParameter.new
  parameter.generate_attr ReaderParameter::SomeClass
  parameter
end

heading 'Generating the attribute' do
  proof 'Adds an attr_reader to the target class' do
    parameter.prove { attr_defined? :name }
  end
end
