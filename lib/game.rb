class Game
  def initialize
    @board = Array.new(7) { Array.new() }
  end

  def push_piece(piece, column)
    @board[column].push(piece) unless @board[column].size >= 6
  end

  def game_over?
    return check_columns_game_over
  end

  private

  def check_columns_game_over    
    7.times { |col| return true if check_column(col) }    
    return false
  end

  def check_column(col)
    color_count = 1
    @board[col].each_index do |i|
      cur_piece = @board[col][i]
      next_piece = @board[col][i+1]
      return false unless next_piece
      color_count = (cur_piece.color == next_piece.color ? color_count + 1 : 1)
      return true if color_count == 4
      return false if color_count < (5 - i) 
    end
  end
end