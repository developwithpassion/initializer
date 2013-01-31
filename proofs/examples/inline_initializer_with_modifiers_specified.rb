require_relative '../proofs_init'

title 'Example - Inline Initializer With Modifiers Specified'
=begin
This example shows how to have a initializer generated using the simplest call mechanism available in the library
=end

module InlineInitializerWithModifiersSpecified
  class Item
    include Initializer 

    initializer r(:name), rw(:age), w(:address)

=begin
  The above is equivalent to the following
  class Item
    attr_reader :name
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
        readers?(:name, :age) &&
        !readers?(:address) &&
        writers?(:age) &&
        !writers?(:name, :age)
      end
    end
  end
end


proof 'Initializer is generated with accessors' do
  name = 'John'
  age = 23
  address = 'Address'

  item = InlineInitializerWithModifiersSpecified::Item.new(name, age, address)

  item.prove { initialized?(name, age, address) }
end
