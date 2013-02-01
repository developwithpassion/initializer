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
      "#{variable_name} = #{name}"
    end

    def parameter_name
      "#{parameter_prefix}#{name}"
    end

    def variable_name
      "@#{name}"
    end

    module Visibility
      module Reader
        def generate_attr(target)
          name = self.name
          target.instance_eval do
            attr_reader name
          end
        end
      end

      module Writer
        def generate_attr(target)
          name = self.name
          target.instance_eval do
            attr_writer name
          end
        end
      end

      module Accessor
        def generate_attr(target)
          name = self.name
          target.instance_eval do
            attr_accessor name
          end
        end
      end

      module NoAccessor
        def generate_attr(target)
        end
      end
    end
  end
end

