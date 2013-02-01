require_relative '../proofs_init'

title 'Initializer DSL'

module Initializer
  class ParameterConfig
    module Proof
      def named?
        parameter_name == :age
      end
      def extension?(mod)
        extension_module == mod
      end
      def reader_parameter?
        extension? Initializer::ReaderParameter
      end
      def writer_parameter?
        extension? Initializer::WriterParameter
      end
      def accessor_parameter?
        extension? Initializer::AccessorParameter
      end
      def no_accessor_parameter?
        extension? Initializer::NoAccessorParameter
      end
    end
  end
end

def config(visibility)
  ::Initializer::ClassMethods.send visibility, :age
end

heading 'Reader macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the ReaderParameter module as its mixin' do
    config(:reader).prove { reader_parameter? && named? }
  end
end

heading 'Writer macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the WriterParameter module as its mixin' do
    config(:writer).prove { writer_parameter? && named? }
  end
end

heading 'Accessor macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the AttrParameter module as its mixin' do
    config(:accessor).prove { accessor_parameter? && named? }
  end
end

heading 'No accessor macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the ParameterWithNoAccessors module as its mixin' do
    config(:no_accessor).prove { no_accessor_parameter? && named? }
  end
end
