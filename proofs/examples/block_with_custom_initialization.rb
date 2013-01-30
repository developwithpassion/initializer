require_relative '../proofs_init'

title 'Example - Block with custom initialization logic'
=begin
This example shows how to have a ctor generated using the block configuration style and taking advantage of being
able to add custom "ctor" logic. The block provided to the extra_initialization call will be executed in the binding
scope of the item being instantiated.
=end

class BlockWithCustomInitializationLogic
 include Initializer 
 
 initializer do
   param :name
   param :age
   param :address
   extra_initialization { @ran = true }
 end

=begin
  The above is the equivalent of the following
  def initialize(name, age, address)
    @name = name
    @age = age
    @address = address
    @ran = true
  end
=end

 module Proof
   def initialized_correctly?(name, age, address)
     @name == name && 
       @age == age && 
       @address == address &&
     @ran
   end
 end
end

proof 'Ctor should be generated correctly' do
  name = 'John'
  age = 23
  address = 'Some House'
  item = BlockWithCustomInitializationLogic.new(name, age, address)
  item.prove { initialized_correctly?(name, age, address) }
end
