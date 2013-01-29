class Items
  attr_reader :items
  def initialize(name,&items)
    @items = items
  end
end

item = Items.new('This',1,4,5,[1,2,3])
p item.items
