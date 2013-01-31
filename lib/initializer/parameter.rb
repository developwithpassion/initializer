module Initializer
  class Parameter
    attr_reader :name
    attr_reader :parameter_prefix

    def initialize(name, prefix)
      @name = name
      @parameter_prefix = prefix
    end

    def self.build_regular_parameter(name)
      new name, ''
    end
    def self.build_splat_parameter(name)
      new name, "*"
    end
    def self.build_block_parameter(name)
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

