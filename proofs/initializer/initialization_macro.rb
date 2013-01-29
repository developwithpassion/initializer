require_relative '../proofs_init'

title 'Initialization Macro'

class Item
  include Initializer
  attr_accessor :name,:age
  attr_accessor :value_set_by_custom_initialization
end

module Initializer
  class InitializationMacro
    module Proof
      def initializes_variables_on_creation?
        param :name
        param :age
        expand

        item = target_class.new('John',23)

        item.name == 'John' && item.age = 23
      end

      def runs_custom_initialization?
        param :name
        param :age
        extra_initialization do
          @value_set_by_custom_initialization = 42
        end
        expand
        item = target_class.new('John',23)
        item.value_set_by_custom_initialization == 42
      end

      def added_to_constant_on_target?
        param :name
        param :age
        expand
        Item::CTOR_BUILT_BY_INITIALIZER == self
      end

      def stored_parameter?(name)
        param name 
        parameters.has_key?(name)
      end

      def enriches_class?(target)
        target_class == target
      end

      def configured_parameter?(name)
        configured = false
        param name do
          configured = true
        end
        configured
      end

      def can_only_have_one_splat_parameter?(name)
        had_no_splat_param = splat_parameter.nil?
        splat_param name
        begin
          splat_param name
        rescue
          return had_no_splat_param && !splat_parameter.nil?
        end
        false
      end

      def can_only_have_one_block_parameter?(name)
        had_no_block_param = block_parameter.nil?
        block_param name
        begin
          block_param name
        rescue
          return had_no_block_param && !block_parameter.nil?
        end
        false
      end
    end
  end
end


def initializer(&configuration_block)
  Initializer::InitializationMacro.new Item
end

proof 'An initialization stores its target class when created' do
  initializer.prove { enriches_class? Item }
end


proof 'An initialization macro should maintain a list of its own parameter definitions' do
  macro = Initializer::InitializationMacro.new Item
  macro.prove { stored_parameter? :name }
end

proof 'An initialization macro should configure a new parameter using the parameter configuration block' do
  macro = Initializer::InitializationMacro.new Item
  macro.prove { configured_parameter? :name }
end

proof 'An initialization macro should only be able to have a singular splat parameter defined' do
  macro = Initializer::InitializationMacro.new Item
  macro.prove { can_only_have_one_splat_parameter? :name }
end

proof 'An initialization macro should only be able to have a singular block parameter defined' do
  macro = Initializer::InitializationMacro.new Item
  macro.prove { can_only_have_one_block_parameter? :name }
end

proof 'An initialization macro generates a ctor on the target class that does initialization of specified parameters' do
  initializer.prove { initializes_variables_on_creation? }
end

proof 'An initialization macro stores itself on a constant of its target class when it is expanded, so that is can be leveraged later on when the actual instance is created' do
  initializer.prove { added_to_constant_on_target? }
end

proof 'An initialization macro runs custom initialization when an instance of its target class is created' do
  initializer.prove { runs_custom_initialization? }
end
