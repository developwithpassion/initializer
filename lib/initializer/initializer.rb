module Initializer
  def self.included(base)
    base.extend ClassMethods
  end

  def run_custom_initialization
    self.class::INITIALIZER_MACRO.run_custom_initialization self
  end

  module ClassMethods
    def initializer(*parameter_names, &configuration_block)
      macro = InitializationMacro.new(self)

      parameter_names.each do|name|
        macro.param name
      end

      macro.instance_eval &configuration_block if block_given?
      macro.expand
    end
  end
end
