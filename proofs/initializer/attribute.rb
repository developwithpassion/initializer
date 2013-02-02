require_relative '../proofs_init'

title 'Attribute'

module Attribute
  extend self

  def some_class
    klass = Class.new do
      def self.writer_defined?(name)
        method_defined? "#{name}="
      end
      def self.reader_defined?(name)
        method_defined? name
      end
    end
    klass
  end
end

def define_attribute(target_class, attribute_name, visibility)
  Initializer::Attribute.define(target_class, attribute_name,
                                           visibility)
end

name = :age
heading 'Reader Attribute' do
  proof 'Adds a reader to the target class' do
    target_class = Attribute.some_class
    attribute = define_attribute(target_class, name, :reader)
    target_class.prove { reader_defined? name }
  end
end
heading 'Writer Attribute' do
  proof 'Adds a writer to the target class' do
    target_class = Attribute.some_class
    attribute = define_attribute(target_class, name, :writer)
    target_class.prove { writer_defined?(name) && ! reader_defined?(name) }
  end
end
heading 'Accessor Attribute' do
  proof 'Adds a reader and writer to the target class' do
    target_class = Attribute.some_class
    attribute = define_attribute(target_class, name, :accessor)
    target_class.prove { writer_defined?(name) && reader_defined?(name) }
  end
end

heading 'No Accessor Attribute' do
  proof 'Adds no readers or writers to the target class' do
    target_class = Attribute.some_class
    attribute = define_attribute(target_class, name, :no_accessor)
    target_class.prove { !writer_defined?(name) && !reader_defined?(name) }
  end
end

