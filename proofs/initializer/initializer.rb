require_relative '../proofs_init'

title 'Initializer Module'

class SomeItem
  include Initializer
end

class SomeItemThatUsesTheInitializer
  include Initializer

  initializer :name, :age, :address

  module Proof
    def ctor_generated_correctly?(name, age, address)
      @name == name && 
      @age == age &&
      @address == address
    end
  end
end

heading 'Using the initializer class method'

proof 'Generates an initializer on the target type with the right ctor args and automatic initialization' do
  name = 'John'
  age = '33'
  address = 'Some House'

  item = SomeItemThatUsesTheInitializer.new(name, age, address)

  item.prove { ctor_generated_correctly?(name, age, address) }
end
