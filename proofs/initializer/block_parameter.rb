require_relative '../proofs_init'

title 'Block Parameter'

module Initializer
  class BlockParameter
    module Proof
      def well_formed_parameter_name?(expected)
        method_parameter_name == expected
      end
      def generated_assignment_statement?(expected)
        assignment_statement == expected
      end
    end
  end
end

def parameter(name, &config_block)
  parameter = Initializer::BlockParameter.new name
  parameter.instance_eval &config_block if block_given?
  parameter
end

proof 'A block parameter should display its parameter name with a & in front of it' do
  parameter = parameter(:name)
  parameter.prove { well_formed_parameter_name?("&name") }
end

proof 'A block parameter should generate its assignment statement by assigning its parameter name to its class variable name without the & operator' do
  parameter = parameter(:name)
  parameter.prove { generated_assignment_statement? "@name = name" }
end

