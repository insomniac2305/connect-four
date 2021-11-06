class Player

  attr_reader :name, :color
  def initialize(name = 'empty', color = '')
    @name = name
    @color = color
  end
end