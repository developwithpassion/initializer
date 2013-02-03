require_relative '../proofs_init'

title 'Initializer With Parameter Visibility'


module InitializerWithParameterVisibility
  class SomeClass
    include Initializer

    initializer r(:name), a(:age), w(:address), na(:city)

    module Proof
      def read?(*names)
        names.all?{|name| respond_to?(name)}
      end
      def write?(*names)
        names.all?{|name| respond_to?("#{name}=")}
      end

      def initialized?(name, age, address, city)
        @name == name && 
          @age == age &&
            @address == address &&
             @city == city
      end
    end
  end
end

heading 'Without visibility' do
  name = 'some name'
  age = 'some age'
  address = 'some address'
  city = 'some city'

  create_item = Proc.new do
    obj = InitializerWithParameterVisibility::SomeClass.new(name, age, address, city)
    obj
  end

  proof 'Attributes are initialized' do
    item = create_item.call

    item.prove { initialized?(name, age, address, city) }
  end

  proof 'Read write parameter creates a accessor attribute' do
    item = create_item.call

    item.prove { read?(:age) && write?(:age) }
  end

  proof 'Write parameter creates a writer attribute' do
    item = create_item.call

    item.prove { write?(:address) && !read?(:address) }
  end

  proof 'No Accessor parameter creates a no accessors attribute' do
    item = create_item.call

    item.prove { !write?(:city) && !read?(:city) }
  end
end
