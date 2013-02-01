require_relative '../proofs_init'

title 'Generate Attributes'

def some_class(visibility_extension)
  parameter = Initializer::Parameter.new :name
  parameter.extend visibility_extension
  klass = parameter.generate_attr Class.new
  klass
end

visibility = Initializer::Parameter::Visibility

heading 'Reader' do
  proof 'Adds a reader to the target class' do
    klass = some_class(visibility::Reader)
    klass.prove { method_defined? :name }
  end
end

heading 'Writer' do
  proof 'Adds a writer to the target class' do
    klass = some_class(visibility::Writer)
    klass.prove { method_defined? :name= }
  end
end

heading 'Accessor' do
  proof 'Adds an accessor to the target class' do
    klass = some_class(visibility::Accessor)
    klass.prove { method_defined?(:name) && method_defined?(:name=) }
  end
end

heading 'No Accessor' do
  proof "Doesn't and an accessor to the target class" do
    klass = some_class(visibility::NoAccessor)
    klass.prove { !method_defined?(:name) && !method_defined?(:name=) }
  end
end
