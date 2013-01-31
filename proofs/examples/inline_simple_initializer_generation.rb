require_relative '../proofs_init'

title 'Example - Inline Simple Initializer Generation'
=begin
This example shows how to have a initializer generated using the simplest call mechanism available in the library
=end

module InlineSimpleInitializerGeneration
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

  item = InlineSimpleInitializerGeneration::Item.new(name, age, address)

  item.prove { initialized?(name, age, address) }
end
