require_relative '../proofs_init'

heading 'Initializer With Parameter Visibility'

=begin
This example shows how to use initializer to generate a ctor that specifies attribute visibility for the ctor parameters
=end

module InitializerWithParameterVisibility
  class SomeClass
    include Initializer 

    initializer r(:name), rw(:age), w(:address)

=begin
  The above is equivalent to the following
  class SomeClass
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

  obj = InitializerWithParameterVisibility::SomeClass.new(name, age, address)

  obj.prove { initialized?(name, age, address) }
end
