class Piece

  attr_reader :color
  def initialize(color = '')
    @color = color
  end

  def to_s
    case color
    when 'green'
      "\e[32m\u25cf\e[0m"
    when 'red'
      "\e[31m\u25cf\e[0m"
    else
      "\u25cf"
    end
  end
end