require_relative '../proofs_init'

title 'Initializer Module'


module InitializerModule
  class SomeClass
    include Initializer

    initializer :name, :age, :address

    module Proof
      def generated?(name, age, address)
        @name == name && 
          @age == age &&
          @address == address
      end
    end
  end

  class ClassMethodHarness
    include ::Initializer::ClassMethods
  end
end

heading 'The initializer macro style method' do
  proof 'Generates the initializer with the specified args and variable initialization' do
    name = 'John'
    age = '33'
    address = 'Some House'

    item = InitializerModule::SomeClass.new(name, age, address)

    item.prove { generated?(name, age, address) }
  end
end
