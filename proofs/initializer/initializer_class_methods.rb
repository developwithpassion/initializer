require_relative '../proofs_init'

title 'Initializer Class Methods'

module InitializerClassMethods
  class SomeClass
    include ::Initializer::ClassMethods
    include ::Proof
  end
end

module InitializerClassMethods
  class SomeClass
    module Proof
      def creates_read_parameter_configuration?(name)
        param = reader name
        param.extension_module == Initializer::ReaderParameter
      end
      def creates_no_accessor_parameter_configuration?(name)
        param = no_accessor name
        param.extension_module == Initializer::NoAccessorParameter
      end
      def creates_write_parameter_configuration?(name)
        param = writer name
        param.extension_module == Initializer::WriterParameter
      end
      def creates_accessor_parameter_configuration?(name)
        param = accessor name
        param.extension_module == Initializer::AccessorParameter
      end
    end
  end
end

def class_methods
  InitializerClassMethods::SomeClass.new
end

heading 'Reader macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the ReaderParameter module as its mixin' do
    class_methods.prove { creates_read_parameter_configuration? :age }
  end
end

heading 'Writer macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the WriterParameter module as its mixin' do
    class_methods.prove { creates_write_parameter_configuration? :age }
  end
end

heading 'Accessor macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the AttrParameter module as its mixin' do
    class_methods.prove { creates_accessor_parameter_configuration? :age }
  end
end

heading 'No accessor macro style method' do
  proof 'Creates a ParameterConfig with the specified name and the ParameterWithNoAccessors module as its mixin' do
    class_methods.prove { creates_no_accessor_parameter_configuration? :age }
  end
end
