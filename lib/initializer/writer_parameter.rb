module Initializer
  module WriterParameter
    def generate_attr(target)
      name = self.name
      target.instance_eval do
        attr_writer name
      end
    end
  end
end
