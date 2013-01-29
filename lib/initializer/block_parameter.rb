module Initializer
  class BlockParameter
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def assignment_statement
      "#{variable_name} = #{name.to_s}"
    end

    def method_parameter_name
      "&#{name.to_s}"
    end

    def variable_name
      "@#{name.to_s}"
    end
  end
end

