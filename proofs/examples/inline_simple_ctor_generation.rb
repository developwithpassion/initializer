require_relative '../proofs_init'

title 'Inline Simple CTOR Generation'
=begin
This example shows how to have a ctor generated using the simplest call mechanism available in the library - an splat of
names.
=end

class InlineSimpleCTORGeneration
 include Initializer 

 initializer :name,:age,:address

 module Proof
   def initialized_correctly?(name, age, address)
    @name = name   
    @age = age   
    @address = address   
   end
 end
end

proof 'Ctor should be generated correctly' do
  name = 'John'
  age = 23
  address = 'Some House'
  item = InlineSimpleCTORGeneration.new(name, age, address)
  item.prove { initialized_correctly?(name, age, address) }
end