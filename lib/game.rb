class Game
  def initialize
    @board = Array.new(7) { Array.new() }
  end

  def push_piece(piece, column)
    @board[column].push(piece) unless @board[column].size >= 6
  end

  def game_over?
    return check_columns_game_over || check_rows_game_over

  end

  private

  def check_columns_game_over    
    7.times { |col| return true if check_column(col) }    
    return false
  end

  def check_column(col)
    color = nil
    color_count = 1
    @board[col].each do |piece|      
      color_count = (color == piece.color ? color_count + 1 : 1)
      color = piece.color
      return true if color_count == 4
    end
    return false
  end

  def check_rows_game_over
    6.times { |row| return true if check_row(row) }
    return false
  end

  def check_row(row)
    color = nil
    color_count = 1
    7.times do |col|
      piece = @board[col][row]
      return false unless piece
      color_count = (color == piece.color ? color_count + 1 : 1)
      color = piece.color
      return true if color_count == 4
    end
    return false
  end
end