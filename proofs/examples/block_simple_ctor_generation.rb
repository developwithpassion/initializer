require_relative '../proofs_init'

title 'Block Simple CTOR Generation'
=begin
This example shows how to have a ctor generated using the block configuration style call structure, that provides for access
to configure different types of parameters (like splat and block). This example shows the most simple usage of this style
=end

class BlockSimpleCTORGeneration
 include Initializer 
 
 initializer do
   param :name
   param :age
   param :address
 end

 module Proof
   def initialized_correctly?(name, age, address)
     @name == name && 
       @age == age && 
       @address == address
   end
 end
end

proof 'Ctor should be generated correctly' do
  name = 'John'
  age = 23
  address = 'Some House'
  item = BlockSimpleCTORGeneration.new(name, age, address)
  item.prove { initialized_correctly?(name, age, address) }
end
