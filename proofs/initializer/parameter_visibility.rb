require_relative '../proofs_init'

title 'Initializer With Parameter Visibility'

module ParameterVisibility
  class Example
    include Initializer

    initializer r(:arg1), a(:arg2), w(:arg3), na(:arg4)

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
  ParameterVisibility::Example.new(:some_value, :some_value, :some_value, :some_value)
end

proof 'Read parameter creates an attribute reader' do
  example.prove { read?(:arg1) && !write?(:arg1) }
end

proof 'Accessor parameter creates an attribute accessor' do
  example.prove { read?(:arg2) && write?(:arg2) }
end

proof 'Write parameter creates an attribute writer' do
  example.prove { write?(:arg3) && !read?(:arg3) }
end

proof "No Accessor parameter doesn't create an attribute" do
  example.prove { !write?(:city) && !read?(:city) }
end
