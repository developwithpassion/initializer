require 'test/unit/assertions'
include Test::Unit::Assertions


# require_relative '../proofs_init.rb'
require_relative '../../lib/initializer.rb'


class SomeTargetClass
  include Initializer

  initializer :foo, a(:bar), w(:baz), na(:qux), r(:fred)
end

something = SomeTargetClass.new(1,2,3,4,5)

assert something.respond_to?(:foo), "Has getter"
assert !something.respond_to?(:foo=), "Has setter"

assert something.respond_to?(:bar), "Has getter"
assert something.respond_to?(:bar=), "Has setter"

assert !something.respond_to?(:baz), "Has getter"
assert something.respond_to?(:baz=), "Has setter"

assert !something.respond_to?(:qux), "Has getter"
assert !something.respond_to?(:qux=), "Has setter"

assert something.respond_to?(:fred), "Has getter"
assert !something.respond_to?(:fred=), "Has setter"

class SomeTargetClassWithDefaultVisibility
  include Initializer

  initializer :foo, :default => :accessor
end

something = SomeTargetClassWithDefaultVisibility.new(1)

assert something.respond_to?(:foo), "Has getter"
assert something.respond_to?(:foo=), "Has setter"
