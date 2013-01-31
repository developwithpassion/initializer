require_relative '../proofs_init'

title 'Reader Parameter' 

module ReaderParameter
  class SomeClass

  end
  class AParameter
    include Initializer::ReaderParameter
    def name
      :name
    end

    module Proof
      def generates_attr_reader?(target)
        original = target.new
        had_no_reader = !original.respond_to?(:name)
        generate_attr target
        updated = target.new
        had_no_reader && updated.respond_to?(:name)
      end
    end
  end
end

def parameter
  ::ReaderParameter::AParameter.new
end

heading 'Generating the attribute' do
  proof 'Adds an attr_reader to its target class' do
    parameter.prove { generates_attr_reader?(::ReaderParameter::SomeClass) }
  end
end
