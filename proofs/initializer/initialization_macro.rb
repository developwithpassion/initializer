require_relative '../proofs_init'

title 'Initialization Macro'

class Item
  attr_accessor :name,:age
end

module Initializer
  class InitializationMacro
    module Proof
      def initializes_variables_on_creation?
        expand

        item = target_class.new('John',23)

        item.name == 'John' && item.age = 23
      end
    end
  end
end



def initializer
  Initializer::InitializationMacro.new Item, :name,:age
end

proof 'Initializes variables automatically' do
  initializer.prove { initializes_variables_on_creation? }
end

