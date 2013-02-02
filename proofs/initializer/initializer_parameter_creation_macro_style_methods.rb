require_relative '../proofs_init'

title 'Initializer parameter creation macro style methods'

module Initializer
  class Parameter
    module Proof
      def named?(name)
        self.name == name
      end
      def visibility?(visibility)
        self.visibility == visibility
      end
      def reader_visibility?
        visibility? :reader
      end
      def writer_visibility?
        visibility? :writer
      end
      def accessor_visibility?
        visibility? :accessor
      end
      def no_accessor_visibility?
        visibility? :no_accessor
      end
    end
  end
end

def parameter_macro_style
  ::Initializer::ClassMethods
end

name = :address

heading 'Creating parameters' do
  proof 'Creates a read parameter' do
    parameter = parameter_macro_style.r name
    parameter.prove { reader_visibility? }
    parameter.prove { named? name }
  end

  proof 'Creates a write parameter' do
    parameter = parameter_macro_style.w name
    parameter.prove { writer_visibility? }
    parameter.prove { named? name }
  end

  proof 'Creates a accessor parameter' do
    parameter = parameter_macro_style.a name
    parameter.prove { accessor_visibility? }
    parameter.prove { named? name }
  end

  proof 'Creates a no accessor parameter' do
    parameter = parameter_macro_style.na name
    parameter.prove { no_accessor_visibility? }
    parameter.prove { named? name }
  end
end

