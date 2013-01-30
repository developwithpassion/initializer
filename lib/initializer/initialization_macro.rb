module Initializer
  class InitializationMacro
    attr_reader :target_class
    attr_reader :parameters
    attr_accessor :block_parameter
    attr_accessor :splat_parameter
    attr_accessor :extra_initialization_block

    def initialize(target_class,*ctor_parameter_names)
      @target_class = target_class
      @ctor_parameter_names = ctor_parameter_names
      @parameters = {}
    end


    def extra_initialization(&initialization_block)
      @extra_initialization_block = initialization_block
    end

    def run_custom_initialization(target_instance)
      target_instance.instance_eval &extra_initialization_block if extra_initialization_block
    end


    def param(name)
      param = Parameter.build_regular_parameter name
      parameters[param.name] = param
      param
    end

    def splat_param(name, &parameter_configuration_block)
      raise 'Only one splat parameter can be defined for a ctor' unless splat_parameter.nil?
      param = Parameter.build_splat_parameter name
      self.splat_parameter = param
      param
    end

    def block_param(name, &parameter_configuration_block)
      raise 'Only one block parameter can be defined for a ctor' unless block_parameter.nil?
      param = Parameter.build_block_parameter(name)
      self.block_parameter = param
      param
    end

    def complete_parameter_list
      all_parameters = parameters.values.dup.to_a
      all_parameters << splat_parameter if splat_parameter
      all_parameters << block_parameter if block_parameter
      all_parameters
    end

    def parameter_declaration_statement
      parameter_names = complete_parameter_list.map{|item| item.method_parameter_name }.to_a
      parameter_names.join(", ")
    end

    def variable_assignment_statements
      complete_parameter_list.inject("") do|current_assignment_body, parameter|
        "#{current_assignment_body}#{parameter.assignment_statement}\n"
      end
    end

    def build_ctor_definition
      body = 
<<CTOR
        def initialize(#{parameter_declaration_statement})
          #{variable_assignment_statements}   
          run_custom_initialization
        end
CTOR
    end

    def expand
      body = build_ctor_definition
      target_class.class_eval body
      target_class.const_set(:INITIALIZER_MACRO, self)
    end
  end
end
