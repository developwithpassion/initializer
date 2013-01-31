require_relative '../proofs_init'

title 'Initializer Class Methods'

module InitializerModule
  class ClassMethodHarness
    include ::Initializer::ClassMethods
  end
end

def class_methods
  class_methods = InitializerModule::ClassMethodHarness.new
  class_methods
end

module InitializerModule
  class ClassMethodHarness
    module Proof
      def creates_parameter_configuration?(name, method_to_call, expected_mixin)
        param = send(method_to_call, name)
        param.parameter_name == name 
        param.extension_module == expected_mixin
      end
      def creates_no_accessors_parameter_configuration?(name)
        creates_parameter_configuration?(name, :no_accessors, Initializer::ParameterWithNoAccessors)
      end
      def creates_write_parameter_configuration?(name)
        creates_parameter_configuration?(name, :writer, Initializer::WriterParameter)
      end
      def creates_read_parameter_configuration?(name)
        creates_parameter_configuration?(name, :reader, Initializer::ReaderParameter)
      end
      def creates_accessor_parameter_configuration?(name)
        creates_parameter_configuration?(name, :accessor, Initializer::AccessorParameter)
      end
    end
  end
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
    class_methods.prove { creates_no_accessors_parameter_configuration? :age }
  end
end
