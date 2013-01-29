require_relative '../proofs_init'

title 'Parameters'

module Initializer
  class Parameter
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
  parameter = Initializer::Parameter.new name
  parameter.instance_eval &config_block if block_given?
  parameter
end

proof 'A regular parameter should display its parameter name without any special character' do
  parameter = parameter(:name)
  parameter.prove { well_formed_parameter_name?("name") }
end

proof 'A parameter should generate its assignment statement by assignments its parameter name to its class variable name' do
  parameter = parameter(:name)
  parameter.prove { generated_assignment_statement? "@name = name" }
end

