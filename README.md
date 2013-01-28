initialization
======

`initialization` gem enables a simple declaritive initializer model

## Installation

Install the gem itself.

    [PROJECTS]$ git clone ssh://git@$REPOSITORY_PATH/initialization.git
    [PROJECTS]$ cd initialization
    [PROJECTS/initialization]$ gem install bundler
    [PROJECTS/initialization]$ gem install path_gem
    [PROJECTS/initialization]$ bundle

Make the gem available for `path-gem`.

    cd $PATH_GEM_DIR
    [PATH_GEM_DIR]$ ln -s $PROJECTS/initialization initialization

## Usage

### include initialization and use the initialize_with macro to define the ctor and automatic initialization
```ruby
class SomeItem
  include Initialization

  initialize_with :name, :age, :address
end
```

The above usage would be the equivalent of :
```ruby
class SomeItem
 def initialize(name, age, address)
    @name = name
    @age = age
    @address = address
 end
end
```
