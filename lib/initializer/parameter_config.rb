module Initializer
  class ParameterConfig
    attr_reader :name
    attr_reader :extension_module

    def initialize(name, extension_module)
      @name = name
      @extension_module = extension_module
    end
    def configure(macro)
      param = macro.add_parameter name
      param.extend extension_module
    end
  end
end
