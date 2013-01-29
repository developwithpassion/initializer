module Initializer
  class Parameter
    attr_reader :name
    attr_reader :method_parameter_prefix

    def initialize(name, prefix)
      @name = name
      @method_parameter_prefix = prefix
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

    def method_parameter_name
      "#{method_parameter_prefix}#{name.to_s}"
    end

    def variable_name
      "@#{name.to_s}"
    end
  end
end

