require_relative '../proofs_init'

title 'Writer Parameter' 

module WriterParameter
  class SomeClass

  end
  class AParameter
    include Initializer::WriterParameter
    def name
      :name
    end

    module Proof
      def generates_attr_writer?(target)
        original = target.new
        had_no_writer = !original.respond_to?(:name=)
        generate_attr target
        updated = target.new
        had_no_writer && original.respond_to?(:name=)
      end
    end
  end
end

def parameter
  ::WriterParameter::AParameter.new
end

heading 'Generating the attribute' do
  proof 'Adds an attr_writer to its target class' do
    parameter.prove { generates_attr_writer?(::WriterParameter::SomeClass) }
  end
end
