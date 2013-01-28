require_relative '../proofs_init'

title 'Including the intialization module'

class SomeItem
  include Initialization
end

proof 'Including the module provides the class with access to the initialize_with macro' do
  SomeItem.prove { respond_to? :initialize_with }
end

class SomeItemThatUsesTheInitializer
  include Initialization

  initialize_with :name, :age, :address
end

heading 'Using the initialization macro'

proof 'Generates the appropriate ctor on the target type' do
    item = SomeItemThatUsesTheInitializer.new('John', 33, 'Some House')
    item.prove { !nil? }
end
