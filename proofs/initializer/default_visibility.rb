require_relative '../proofs_init'

title 'Initializer With Default Visibility'

module DefaultVisibilityProofs
  class Example
    include Initializer

    initializer :name, :default => :writer

    module Proof
      def reader?(*names)
        names.all?{|name| respond_to?(name)}
      end
      def writer?(*names)
        names.all?{|name| respond_to?("#{name}=")}
      end
    end
  end
end

def example
  DefaultVisibilityProofs::Example.new :some_value
end

proof "Attribute's visibility is the default visibility" do
  example.prove { !reader?(:name) && writer?(:name) }
end
