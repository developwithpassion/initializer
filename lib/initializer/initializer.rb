module Initializer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def initialize_with(*parameter_names)
      macro = InitializationMacro.new(self,*parameter_names)
      macro.expand
    end
  end
end
