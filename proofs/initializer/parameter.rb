require_relative '../proofs_init'

title 'Parameters'

Parameter = Initializer::Parameter

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



proof 'A regular parameter should display its parameter name without any special character' do
  parameter = Parameter.build_regular_parameter(:name)
  parameter.prove { well_formed_parameter_name?("name") }
end

proof 'A splat parameter should display its parameter name with a * prefix' do
  parameter = Parameter.build_splat_parameter(:name)
  parameter.prove { well_formed_parameter_name?("*name") }
end

proof 'A block parameter should display its parameter name with a & prefix' do
  parameter = Parameter.build_block_parameter(:name)
  parameter.prove { well_formed_parameter_name?("&name") }
end

proof 'A parameter should generate its assignment statement by assigning its parameter name to its class variable name' do
  parameter = Parameter.build_regular_parameter(:name)
  parameter.prove { generated_assignment_statement? "@name = name" }
end

proof 'A block parameter should generate its assignment statement by assigning its parameter name to its class variable name without the & being in the assignment' do
  parameter = Parameter.build_block_parameter(:name)
  parameter.prove { generated_assignment_statement? "@name = name" }
end

proof 'A splat parameter should generate its assignment statement by assigning its parameter name to its class variable name without the * being in the assigment' do
  parameter = Parameter.build_splat_parameter(:name)
  parameter.prove { generated_assignment_statement? "@name = name" }
end
