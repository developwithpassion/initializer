require_relative '../proofs_init'

title 'Block Param'
=begin
  This example shows how to have a ctor generated with a block
  param
=end

class BlockParamExample
  include Initializer

  initializer { block_param :extra_logic }

=begin
  The above is the equivalent of the following
  def initialize(&extra_logic)
    @extra_logic = extra_logic
  end
=end

  module Proof
    def initialized_correctly?
      self.instance_eval &@extra_logic
      @ran == true
    end
  end
end

proof 'Ctor should be generated correctly' do
  item = BlockParamExample.new do
    @ran = true
  end
  item.prove { initialized_correctly? }
end
