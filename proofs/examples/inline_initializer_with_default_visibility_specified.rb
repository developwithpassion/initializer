require_relative '../proofs_init'

title 'Example - Inline Initializer With Default Modifiers Specified'
=begin
This example shows how to have a initializer generated using the simplest call mechanism available in the library
=end

module InlineInitializerWithDefaultModifiersSpecified
  class Item
    include Initializer 

    initializer :name, rw(:age), :address, :visibility => :w

=begin
  The above is equivalent to the following
  class Item
    attr_writer :name
    attr_accessor :age
    attr_writer :address

    def initialize(name, age, address)
      @name = name
      @age = age
      @address = address
    end
  end
=end

    module Proof
      def readers?(*names)
        names.all?{|item| respond_to?(item)}
      end
      def writers?(*names)
        names.all?{|item| respond_to?("#{item}=")}
      end
      def initialized?(name, age, address)
        @name == name &&
        @age == age &&
        @address == address &&
        !readers?(:name, :address) &&
        writers?(:name, :address, :age) &&
        readers?(:age) 
      end
    end
  end
end


proof 'Initializer is generated with accessors' do
  name = 'John'
  age = 23
  address = 'Address'

  item = InlineInitializerWithDefaultModifiersSpecified::Item.new(name, age, address)

  item.prove { initialized?(name, age, address) }
end
