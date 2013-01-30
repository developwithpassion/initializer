require_relative '../proofs_init'

title 'Example - Inline with configuration block'
=begin
This example shows how to have a ctor generated using the simple
inline style in conjunction with custom ctor logic. The block provided
to the extra_initialization call will run in the binding scope of the item
being instantiated.
=end

class InlineWithConfigurationBlock
  include Initializer

  initializer :regexp, :match_block, :summary_block do
    extra_initialization { @lines_processed = 0 }
  end

=begin
  The above is the equivalent of the following
  def initialize(regexp, match_block, summary_block)
    @regexp = regexp
    @match_block = match_block
    @summary_block = summary_block

    @lines_processed = 0
  end
=end

  module Proof
    def initialized_correctly?(regexp, match_block, summary_block)
      @regexp == regexp &&
      @match_block == match_block &&
      @summary_block == summary_block
      @lines_processed == 0
    end
  end
end

proof 'Ctor should be generated correctly' do
  regexp = /.*/
  match_block = -> {}
  summary_block = -> {}
  item = InlineWithConfigurationBlock.new(regexp, match_block, summary_block)
  item.prove { initialized_correctly?(regexp, match_block, summary_block) }
end
