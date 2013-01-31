require_relative '../proofs_init'

title 'No Accessors Parameter' 

module NoAccessorsParameter
  class SomeClass

  end
  class AParameter
    include Initializer::NoAccessorsParameter
    def name
      :name
    end

    module Proof
      def does_not_generate_attrs?(target)
        original = target.new
        had_no_accessors = !(original.respond_to?(:name) || original.respond_to?(:name=))
        generate_attr target

        updated = target.new
        had_no_accessors && 
          !updated.respond_to?(:name) &&
          !updated.respond_to?(:name=)
      end
    end
  end
end

def parameter
  NoAccessorsParameter::AParameter.new
end

heading 'Generating the attribute' do
  proof 'Does not add attributes to the target class' do
    parameter.prove { does_not_generate_attrs?(::NoAccessorsParameter::SomeClass) }
  end
end
