module Initializer
  class Parameter
    attr_reader :name
    attr_reader :parameter_prefix

    def initialize(name, prefix)
      @name = name
      @parameter_prefix = prefix
    end

    def self.regular_parameter(name)
      new name, ''
    end
    def self.splat_parameter(name)
      new name, "*"
    end
    def self.block_parameter(name)
      new name, "&"
    end

    def assignment_statement
      "#{variable_name} = #{name.to_s}"
    end

    def parameter_name
      "#{parameter_prefix}#{name.to_s}"
    end

    def variable_name
      "@#{name.to_s}"
    end

  end
end

