module Initializer
  class InitializationMacro
    attr_reader :target_class
    attr_reader :ctor_parameter_names
    attr_reader :parameters
    attr_reader :parameters
    attr_accessor :block_parameter
    attr_accessor :splat_parameter
    attr_accessor :extra_initialization_block

    def initialize(target_class,*ctor_parameter_names)
      @target_class = target_class
      @ctor_parameter_names = ctor_parameter_names
      @parameters = {}
    end


    def param(name, &parameter_configuration_block)
      parameter = Parameter.new name
      parameter.instance_eval &parameter_configuration_block if block_given?
      parameters[name] = parameter
      self
    end

    def extra_initialization(&initialization_block)
      @extra_initialization_block = initialization_block
    end

    def run_custom_initialization(target_instance)
      target_instance.instance_eval &extra_initialization_block if extra_initialization_block
    end


    def splat_param(name, &parameter_configuration_block)
      raise 'Only one splat parameter can be defined for a ctor' unless splat_parameter.nil?
      splat_parameter = SplatParameter.new(name)
      splat_parameter.instance_eval &parameter_configuration_block if block_given?
      self.splat_parameter = splat_parameter
      self
    end

    def block_param(name, &parameter_configuration_block)
      raise 'Only one block parameter can be defined for a ctor' unless block_parameter.nil?
      block_parameter = BlockParameter.new(name)
      block_parameter.instance_eval &parameter_configuration_block if block_given?
      self.block_parameter = block_parameter
      self
    end

    def complete_parameter_list
      all_parameters = parameters.values.dup.to_a
      all_parameters << splat_parameter.method_parameter_name unless splat_parameter.nil?
      all_parameters << block_parameter.method_parameter_name unless block_parameter.nil?
      all_parameters
    end

    def parameter_declaration_statement
      parameter_names = complete_parameter_list.map{|item| item.method_parameter_name }.to_a
      parameter_names.join(", ")
    end

    def variable_assignment_statements
      initial_assignment_statements = complete_parameter_list.inject("") do|definition, parameter|
        "#{definition}#{parameter.assignment_statement}\n"
      end

    end

    def build_ctor_definition
      body = <<CTOR
        def initialize(#{parameter_declaration_statement})
          
          #{variable_assignment_statements}   

          run_custom_initialization
        end
CTOR
    end

    def expand
      body = build_ctor_definition
      target_class.class_eval body
      target_class.const_set(:CTOR_BUILT_BY_INITIALIZER, self)
    end
  end
end
