require_relative '../proofs_init'

title 'Using everything'
=begin
  This example shows how to have a ctor generated that uses
  a mixture of all the different call structures:
    - inline parameter definition
    - splat parameter
    - block parameter
    - custom ctor logic
=end

class UsingEverything
  include Initializer

  initializer :name, :age, :address do
    param :city
    splat_param :hobbies
    block_param :block_provided_by_client
    extra_initialization { @ran_extra = true }
  end

=begin
  The above is the equivalent of the following

  def initialize(name, age, address, city, *hobbies, &block_provided_by_client)
    @name = name
    @age = age
    @address = address
    @hobbies = hobbies
    @block_provided_by_client = block_provided_by_client
    @ran_extra = true
  end
=end

  module Proof
    def initialized_correctly?(name, age, address, city, hobbies, &other_block)
      @name == name &&
      @address == address &&
      @city == city &&
      @hobbies == hobbies &&
      @block_provided_by_client == other_block
      @ran_extra == true
    end
  end
end

proof 'Ctor should be generated correctly' do
  name = 'John'
  age = 23
  address = 'Address'
  city = 'City'
  hobbies = %w/First Second Third Fourth/
  extra_block = -> { }

  item = UsingEverything.new(name, age, address, city,
                            hobbies, &extra_block)

  item.prove { initialized_correctly?(name, age, address, city, hobbies, &extra_block) }
end
