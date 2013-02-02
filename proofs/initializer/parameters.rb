require_relative '../proofs_init'

title 'Parameter'

module Initializer
  class Parameter
    module Proof
      def visibility?(visibility)
        self.visibility == visibility
      end
      def reader_visibility?
        visibility? :reader
      end
      def writer_visibility?
        visibility? :writer
      end
      def accessor_visibility?
        visibility? :accessor
      end
      def no_accessor_visibility?
        visibility? :no_accessor
      end
    end
  end
end

def visibility
  ::Initializer::ClassMethods
end

name = :address

heading 'Creating parameters with visibility' do

  proof 'Create a read parameter' do
    parameter = visibility.r name

    parameter.prove { reader_visibility? }
  end

  proof 'Create a write parameter' do
    parameter = visibility.w name

    parameter.prove { writer_visibility? }
  end

  proof 'Create a accessor parameter' do
    parameter = visibility.a name

    parameter.prove { accessor_visibility? }
  end

  proof 'Create a no accessor parameter' do
    parameter = visibility.na name

    parameter.prove { no_accessor_visibility? }
  end
end


