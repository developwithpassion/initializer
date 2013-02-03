module Initializer
  class Parameter
    attr_reader :name    
    attr_reader :visibility    

    def initialize(name, visibility)
      @name = name
      @visibility = visibility
    end
  end
end
