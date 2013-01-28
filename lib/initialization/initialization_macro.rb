module Initialization
  class InitializationMacro
    attr_reader :target_class
    attr_reader :ctor_parameter_names

    def initialize(target_class,*ctor_parameter_names)
      @target_class = target_class
      @ctor_parameter_names = ctor_parameter_names
    end


    def build_ctor_definition
      parameter_names = ctor_parameter_names.map{|item| item.to_s }

      variable_initialization_definition = parameter_names.inject("") do|definition, parameter_name|
        "#{definition}@#{parameter_name} = #{parameter_name}\n"
      end

      incoming_parameters_definition = parameter_names.join(", ")
      body = <<CTOR
        def initialize(#{incoming_parameters_definition})
          #{variable_initialization_definition}   
        end
CTOR
    end

    def expand
      body = build_ctor_definition
      target_class.class_eval build_ctor_definition
    end
  end
end
