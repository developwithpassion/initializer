require_relative '../proofs_init'

title 'Accessor Parameter' 

module AttrParameter
  class SomeClass

  end
  class AParameter
    include Initializer::AccessorParameter
    def name
      :name
    end

    module Proof
      def generates_accessor?(target)
        original = target.new
        had_no_accessors = !(original.respond_to?(:name) || original.respond_to?(:name=))
        generate_attr target

        updated = target.new
        had_no_accessors && 
          updated.respond_to?(:name) &&
          updated.respond_to?(:name=)
      end
    end
  end
end

def parameter
  AttrParameter::AParameter.new
end

heading 'Generating the attribute' do
  proof 'Adds an attr_accessor to its target class' do
    parameter.prove { generates_accessor?(::AttrParameter::SomeClass) }
  end
end
