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
  class Item
    attr_reader :name
    attr_reader :age
    attr_reader :address

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
        @name == name  &&
        @age == age  &&
        @address == address  &&
        readers?(:name, :age, :address) &&
        !writers?(:name, :age, :address)
        
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


