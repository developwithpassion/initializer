require_relative '../proofs_init'

title 'Splat Param Example'
=begin
This example shows how to have a ctor generated with a splat
param that does not do expansion on assignment
=end

class SplatParamExample
  include Initializer

  initializer { splat_param :names }

  #The above is the equivalent of the following
  # def initialize(*names)
  #   @names = names
  # end

  module Proof
    def initialized_correctly?(*args)
      @names == args
    end
  end
end

proof 'Ctor should be generated correctly' do
  item = SplatParamExample.new('John','Doe')
  item.prove { initialized_correctly?('John','Doe') }
end
