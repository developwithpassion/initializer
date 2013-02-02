require_relative '../proofs_init'

title 'Initializer With Default Visibility'

module InitializerWithDefaultVisibility
  class SomeClass
    include Initializer

    initializer :name, :default => :writer

    module Proof
      def read?(*names)
        names.all?{|name| respond_to?(name)}
      end
      def write?(*names)
        names.all?{|name| respond_to?("#{name}=")}
      end

      def initialized?(name)
        @name == name 
      end
    end
  end
end

name = 'some name'

create_item = Proc.new do
  obj = InitializerWithDefaultVisibility::SomeClass.new(name)
  obj
end

proof 'Attributes are initialized' do
  item = create_item.call

  item.prove { initialized?(name) }
end

proof "Attribute's visibility is the default visibility" do
  item = create_item.call

  item.prove { !read?(:name) && write?(:name) }
end
