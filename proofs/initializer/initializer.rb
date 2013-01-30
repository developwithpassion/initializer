require_relative '../proofs_init'

title 'Including the intialization module'

class SomeItem
  include Initializer
end

proof 'Provides the class with access to the initializer macro' do
  SomeItem.prove { respond_to? :initializer }
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

heading 'Using the initialization macro'

proof 'Leveraging the initializer macro generates a ctor on the target type with the right ctor args and automatic initialization' do
  name = 'John'
  age = '33'
  address = 'Some House'

  item = SomeItemThatUsesTheInitializer.new(name, age, address)

  item.prove { ctor_generated_correctly?(name, age, address) }
end
