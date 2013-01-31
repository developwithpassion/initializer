module Initializer
  class InitializerMacro
    attr_reader :target_class
    attr_reader :value_parameters
    attr_accessor :block_parameter
    attr_accessor :splat_parameter

    def initialize(target_class)
      @target_class = target_class
      @value_parameters = {}
    end


    def add_parameter(name)
      param = Parameter.regular_parameter name
      value_parameters[param.name] = param
      param
    end

    def add_splat_param(name, &parameter_configuration_block)
      raise 'Only one splat parameter can be defined for an initializer' unless splat_parameter.nil?
      param = Parameter.splat_parameter name
      self.splat_parameter = param
      param
    end

    def add_block_param(name, &parameter_configuration_block)
      raise 'Only one block parameter can be defined for an initializer' unless block_parameter.nil?
      param = Parameter.block_parameter(name)
      self.block_parameter = param
      param
    end

    def parameters
      parameters = value_parameters.values.dup.to_a
      parameters << splat_parameter if splat_parameter
      parameters << block_parameter if block_parameter
      parameters
    end

    def parameter_names
      parameter_names = parameters.map{|item| item.parameter_name }.to_a
      parameter_names = parameter_names.join(", ")
      parameter_names
    end

    def variable_assignment_statements
      parameters.inject("") do|current_assignment_body, parameter|
        "#{current_assignment_body}#{parameter.assignment_statement}\n"
      end
    end

    def build_initializer_definition
      body = 
<<CTOR
        def initialize(#{parameter_names})
          #{variable_assignment_statements}   
        end
CTOR
    end

    def define_initializer
      body = build_initializer_definition
      target_class.class_eval body
      parameters.each do|parameter|
        if (parameter.respond_to? :generate_attr)
          parameter.generate_attr target_class
        end
      end
    end
  end
end
