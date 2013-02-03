require_relative '../proofs_init'

title 'Attribute'

module AttributeProofs
  extend self

  def example
    proof = nil
    klass = Class.new do

      proof = Module.new do
        def writer_defined?(name)
          method_defined? "#{name}="
        end
        def reader_defined?(name)
          method_defined? name
        end
      end

    end
    klass.const_set "Proof", proof
    klass
  end
end

def define_attribute(target_class, attribute_name, visibility)
  Initializer::Attribute.define(target_class, attribute_name, visibility)
end

heading 'Reader Attribute' do
  name = :some_attribute

  proof 'Adds a reader to the target class' do
    target_class = AttributeProofs.example
    attribute = define_attribute(target_class, name, :reader)
    target_class.prove { reader_defined? name }
  end
end

heading 'Writer Attribute' do
  name = :some_attribute

  proof 'Adds a writer to the target class' do
    target_class = AttributeProofs.example
    attribute = define_attribute(target_class, name, :writer)
    target_class.prove { writer_defined?(name) && ! reader_defined?(name) }
  end
end

heading 'Accessor Attribute' do
  name = :some_attribute

  proof 'Adds a reader and writer to the target class' do
    target_class = AttributeProofs.example
    attribute = define_attribute(target_class, name, :accessor)
    target_class.prove { writer_defined?(name) && reader_defined?(name) }
  end
end

heading 'No Accessor Attribute' do
  name = :some_attribute

  proof 'Adds no readers or writers to the target class' do
    target_class = AttributeProofs.example
    attribute = define_attribute(target_class, name, :no_accessor)
    target_class.prove { !writer_defined?(name) && !reader_defined?(name) }
  end
end
