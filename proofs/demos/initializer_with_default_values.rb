require_relative '../proofs_init'

title 'Initializer With Default Values'

=begin
This example shows how to use initializer to generate a ctor that includes default values for ctor parameters
=end

module InitializerWithDefaultValues
  class SomeClass
    include Initializer 

    initializer w(:name, 'JP Boodhoo'), rw(:age, 23), rw(:address, 'Address'), rw(:other, deferred('DateTime.now')), r(:a_symbol, :hello)

=begin
  The above is equivalent to the following
  class SomeClass
    attr_writer :name
    attr_accessor :age
    attr_writer :address

    def initialize(name='JP Boodhoo', age=23, address='Address', other=DateTime.now, a_statementsymbol='hello')
      @name = name
      @age = age
      @address = address
      @a_statement = a_statement
      @a_symbol = a_symbol
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
        @other.is_a?(DateTime) &&
        @a_symbol == 'hello'
      end
    end
  end
end


proof 'Initializer is generated with accessors initialized to default values' do
  name = 'JP B'
  age = 23
  address = 'Address'

  obj = InitializerWithDefaultValues::SomeClass.new name

  obj.prove { initialized?(name, age, address) }
end
