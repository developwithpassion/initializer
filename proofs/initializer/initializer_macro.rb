require_relative '../proofs_init'

title 'Initializer Macro Class'

module InitializerMacro
  class Item
    include Initializer
    attr_accessor :name,:age
  end

end

module Initializer
  class InitializerMacro
    module Proof
      def initializes_variables?
        add_regular_parameter :name
        add_regular_parameter :age

        define_initializer

        item = target_class.new('John',23)

        item.name == 'John' && item.age = 23
      end


      def stored_parameter?(name)
        add_regular_parameter name 
        regular_parameters.has_key?(name)
      end

      def can_only_have_one_splat_parameter?(name)
        had_no_splat_param = splat_parameter.nil?
        add_splat_param name
        begin
          add_splat_param name
        rescue
          return had_no_splat_param && !splat_parameter.nil?
        end
        false
      end

      def can_only_have_one_block_parameter?(name)
        had_no_block_param = block_parameter.nil?
        add_block_param name
        begin
          add_block_param name
        rescue
          return had_no_block_param && !block_parameter.nil?
        end
        false
      end
    end
  end
end


def macro
  macro = Initializer::InitializerMacro.new InitializerMacro::Item
  macro
end


proof 'Keeps a list of the value parameter definitions' do
  macro.prove { stored_parameter? :name }
end

proof 'Can have a single splat parameter' do
  macro.prove { can_only_have_one_splat_parameter? :name }
end

proof 'Can have a single block parameter' do
  macro.prove { can_only_have_one_block_parameter? :name }
end

proof 'Generates an initializer on the target class that assigns the parameters to variables' do
  macro.prove { initializes_variables? }
end

