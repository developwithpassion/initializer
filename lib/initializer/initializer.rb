module Initializer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def initializer(*parameter_names)
      macro = InitializerMacro.new(self)

      parameter_names.each do|name|
        macro.param name
      end

      macro.define_initializer
    end
  end
end
