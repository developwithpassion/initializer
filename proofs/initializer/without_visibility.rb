require_relative '../proofs_init'

title 'Initializer Without Visibility'

module WithoutVisibilityProofs
  class Example
    include Initializer

    initializer :name

    module Proof
      def read?(*names)
        names.all?{|name| respond_to?(name)}
      end
      def write?(*names)
        names.all?{|name| respond_to?("#{name}=")}
      end
    end
  end
end

def example
  obj = WithoutVisibilityProofs::Example
end

proof 'Attributes are readonly' do
  example.prove { read?(:name) && !write?(:name) }
end
