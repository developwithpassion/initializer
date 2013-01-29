require_relative '../proofs_init'

title 'Splat Parameter'

module Initializer
  class SplatParameter
    module Proof
      def well_formed_parameter_name?(expected)
        method_parameter_name == expected
      end
      def generated_assignment_statement?(expected, expand = false)
        expand_assignment if expand
        assignment_statement == expected
      end
    end
  end
end

def parameter(name, &config_block)
  parameter = Initializer::SplatParameter.new name
  parameter.instance_eval &config_block if block_given?
  parameter
end

proof 'A splat parameter should display its parameter name with a * in front of it' do
  parameter = parameter(:name)
  parameter.prove { well_formed_parameter_name?("*name") }
end
 
proof 'A splat parameter that is set to expand should generate its assignment statement by assigning its parameter name to its class variable name with the * operator' do
  parameter = parameter(:name)
  parameter.prove { generated_assignment_statement?("@name = *name", true) }
end

 
proof 'A splat parameter that is not set to expand on initialization should generate its assignment statement by assigning its parameter name to its class variable name without the * operator' do
  parameter = parameter(:name)
  parameter.prove { generated_assignment_statement? "@name = name" }
end
