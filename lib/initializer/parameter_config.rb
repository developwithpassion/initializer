module Initializer
  class ParameterConfig
    attr_reader :parameter_name
    attr_reader :extension_module

    def initialize(parameter_name, extension_module)
      @parameter_name = parameter_name
      @extension_module = extension_module
    end

    def configure(macro)
      param = macro.add_parameter parameter_name
      param.extend extension_module
    end
  end
end
