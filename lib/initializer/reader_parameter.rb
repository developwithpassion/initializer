module Initializer
  module ReaderParameter
    def generate_attr(target)
      name = self.name
      target.instance_eval do
        attr_reader name
      end
    end
  end
end
