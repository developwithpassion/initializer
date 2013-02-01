module Initializer
  class Attribute
    attr_reader :parameter_name
    attr_reader :visibility_extension

    def initialize(parameter_name, visibility_extension)
      @parameter_name = parameter_name
      @visibility_extension = visibility_extension
    end

    def configure(macro)
      param = macro.add_regular_parameter parameter_name
      param.extend visibility_extension
    end
  end
end
