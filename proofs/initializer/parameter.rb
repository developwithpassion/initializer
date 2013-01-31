require_relative '../proofs_init'

title 'Parameters' 

Parameter = Initializer::Parameter

module Initializer
  class Parameter
    module Proof
      def parameter_named?(expected)
        parameter_name == expected
      end
      def assignment_statement?(expected)
        assignment_statement == expected
      end
    end
  end
end

proof 'Generate an assignment statement that assigs the parameter to an instance variable' do
  parameter = Parameter.regular_parameter(:name)
  parameter.prove { assignment_statement? "@name = name" }
end

heading 'Regular Parameter' do
  proof 'Parameter name has no prefix' do
    parameter = Parameter.regular_parameter(:name)
    parameter.prove { parameter_named?("name") }
  end
end

heading 'Splat Parameter' do
  proof 'Parameter name has a * prefix' do
    parameter = Parameter.splat_parameter(:name)
    parameter.prove { parameter_named?("*name") }
  end
end


heading 'Block Parameter' do
  def block_parameter
    parameter = Parameter.block_parameter(:name)
    parameter
  end

  proof 'Parameter name has a & prefix' do
    block_parameter.prove { parameter_named?("&name") }
  end
end
