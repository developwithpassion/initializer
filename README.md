initializer
======

`initializer` gem enables a simple declaritive initializer model

## Installation

Install the gem itself.

    [PROJECTS]$ git clone ssh://git@$REPOSITORY_PATH/initializer.git
    [PROJECTS]$ cd initializer
    [PROJECTS/initializer]$ gem install bundler
    [PROJECTS/initializer]$ gem install path_gem
    [PROJECTS/initializer]$ bundle

Make the gem available for `path-gem`.

    cd $PATH_GEM_DIR
    [PATH_GEM_DIR]$ ln -s $PROJECTS/initializer initializer

## Usage

### include initializer and use the initialize_with macro to define the ctor and automatic initializer
```ruby
class SomeItem
  include initializer

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
