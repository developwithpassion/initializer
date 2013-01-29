module Initializer
  class SplatParameter
    attr_reader :name
    attr_reader :expand_when_assigning

    def initialize(name)
      @name = name
    end

    def expand_assignment
      @expand_when_assigning = true
    end

    def assignment_statement
      statement = "#{variable_name} = "
      statement_terminator = expand_when_assigning ? "*" : ""
      statement = "#{statement}#{statement_terminator}#{name.to_s}"
      statement
    end

    def method_parameter_name
      "*#{name.to_s}"
    end

    def variable_name
      "@#{name.to_s}"
    end
  end
end

