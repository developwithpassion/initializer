require_relative '../proofs_init'

title 'Initializer Without Visibility'


module InitializerWithoutVisibility
  class SomeClass
    include Initializer

    initializer :name

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

heading 'Without visibility' do
  name = 'some name'

  create_item = Proc.new do
    obj = InitializerWithoutVisibility::SomeClass.new(name)
    obj
  end

  proof 'Attributes are initialized' do
    item = create_item.call

    item.prove { initialized?(name) }
  end

  proof 'Attributes are readonly' do
    item = create_item.call

    item.prove { read?(:name) && !write?(:name) }
  end
end
