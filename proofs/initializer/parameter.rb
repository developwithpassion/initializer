require_relative '../proofs_init'

title 'Parameters' 

Parameter = Initializer::Parameter

module Initializer
  class Parameter
    module Proof
      def well_formed_parameter_name?(expected)
        parameter_name == expected
      end
      def generated_assignment_statement?(expected)
        assignment_statement == expected
      end
    end
  end
end



heading 'Regular Parameter' do
  proof 'Display its parameter name without any special character' do
    parameter = Parameter.build_regular_parameter(:name)
    parameter.prove { well_formed_parameter_name?("name") }
  end
end

heading 'Splat Parameter' do
  proof 'Displays its parameter name with a * prefix' do
    parameter = Parameter.build_splat_parameter(:name)
    parameter.prove { well_formed_parameter_name?("*name") }
  end
end


heading 'Block Parameter' do
  def block_parameter
    parameter = Parameter.build_block_parameter(:name)
    parameter
  end

  proof 'Displays its parameter name with a & prefix' do
    block_parameter.prove { well_formed_parameter_name?("&name") }
  end

  proof 'Generates an assignment statement by assigning its parameter name to its class variable name without the & being in the assignment ex (@name = name)' do
    block_parameter.prove { generated_assignment_statement? "@name = name" }
  end
end


heading 'Regular and block parameters' do
  proof 'Generates an assignment statement by assigning its parameter name to its class variable name' do
    parameter = Parameter.build_regular_parameter(:name)
    parameter.prove { generated_assignment_statement? "@name = name" }
  end
end
