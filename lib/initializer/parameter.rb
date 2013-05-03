module Initializer
  class Parameter
    attr_reader :name    
    attr_reader :visibility    
    attr_reader :default    

    def initialize(name, visibility)
      @name = name
      @visibility = visibility
    end

    def default_value(value)
      @default = value
    end

    def argument_definition
      if @default
        return "#{@name} = #{default.code_fragment}"
      else
        return @name
      end
    end

    def self.build_default_value(value)
      result = value

      unless result.respond_to?(:code_fragment)
        if result.is_a?(String) || result.is_a?(Symbol)
          result = StringDefaultValue.new(value.to_s)
        else
          result = Statement.new(value)
        end
      end
      result
    end

    def self.build(name, visibility, default = NO_DEFAULT_VALUE)
      instance = new(name, visibility)

      unless default.eql?(NO_DEFAULT_VALUE)
        default = build_default_value(default)
        instance.default_value(default)
      end

      instance
    end
  end
end
