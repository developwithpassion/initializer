require_relative '../proofs_init'

title 'Attribute Visibility'

module Initializer
  class Attribute
    module Proof
      def named?
        parameter_name == :age
      end
      def visibility?(mod)
        visibility_extension == mod
      end
      def reader_visibility?
        visibility? Parameter::Visibility::Reader
      end
      def writer_visibility?
        visibility? Parameter::Visibility::Writer
      end
      def accessor_visibility?
        visibility? Parameter::Visibility::Accessor
      end
      def no_accessor_visibility?
        visibility? Parameter::Visibility::NoAccessor
      end
    end
  end
end

def attribute(visibility)
  ::Initializer::ClassMethods.send visibility, :age
end

heading 'Reader macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the ReaderParameter module as its mixin' do
    attribute(:reader).prove { reader_visibility? && named? }
  end
end

heading 'Writer macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the WriterParameter module as its mixin' do
    attribute(:writer).prove { writer_visibility? && named? }
  end
end

heading 'Accessor macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the AttrParameter module as its mixin' do
    attribute(:accessor).prove { accessor_visibility? && named? }
  end
end

heading 'No accessor macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the ParameterWithNoAccessors module as its mixin' do
    attribute(:no_accessor).prove { no_accessor_visibility? && named? }
  end
end
