module Initializer
  class Parameter
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def assignment_statement
      "#{variable_name} = #{method_parameter_name}"
    end

    def method_parameter_name
      name.to_s
    end

    def variable_name
      "@#{method_parameter_name}"
    end
  end
end

