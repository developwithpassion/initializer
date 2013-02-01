require_relative '../proofs_init'

title 'No Accessor Parameter' 

module NoAccessorParameter
  class SomeClass
    # Accessors are added to this class
  end

  class SomeParameter
    include Initializer::NoAccessorParameter

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
  NoAccessorParameter::SomeParameter.new
end

heading 'Generating the attribute' do
  proof 'Does not add attributes to the target class' do
    parameter.prove { does_not_generate_attrs?(::NoAccessorParameter::SomeClass) }
  end
end
