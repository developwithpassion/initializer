require_relative '../proofs_init'

title 'Example - Inline Simple CTOR Generation'
=begin
This example shows how to have a ctor generated using the simplest call mechanism available in the library
=end

module InlineSimpleCTORGeneration
  class Item
    include Initializer 

    initializer :name,:age,:address

=begin
  The above is the equivalent of the following
  def initialize(name, age, address)
    @name = name
    @age = age
    @address = address
  end
=end

    module Proof
      def initialized?(name, age, address)
        @name = name   
        @age = age   
        @address = address   
      end
    end
  end
end

proof 'Initializer is generated' do
  name = 'John'
  age = 23
  address = 'Some House'

  item = InlineSimpleCTORGeneration::Item.new(name, age, address)

  item.prove { initialized?(name, age, address) }
end
