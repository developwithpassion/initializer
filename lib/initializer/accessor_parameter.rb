module Initializer
  module AccessorParameter
    def generate_attr(target)
      name = self.name
      target.instance_eval do
        attr_accessor name
      end
    end
  end
end
