class Game

  @@BOARD_WIDTH = 7
  @@BOARD_HEIGHT = 6

  def initialize
    @board = Array.new(@@BOARD_WIDTH) { Array.new() }
  end

  def push_piece(piece, column)
    @board[column].push(piece) unless @board[column].size >= @@BOARD_HEIGHT
  end

  def game_over?
    return check_columns_game_over || check_rows_game_over || check_diagonals_game_over
  end

  def board_full?
    return @board.all? {|col| col.size >= @@BOARD_HEIGHT}
  end

  def get_input
    input = gets.to_i
    until input.between?(1, 7) do
      puts 'Wrong input!'
      input = gets.to_i
    end
    return input
  end

  private

  def check_columns_game_over    
    @@BOARD_WIDTH.times { |col| return true if check_column(col) }    
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
    @@BOARD_HEIGHT.times { |row| return true if check_row(row) }
    return false
  end

  def check_row(row)
    color = nil
    color_count = 1
    @@BOARD_WIDTH.times do |col|
      piece = @board[col][row]
      unless piece
        color = nil
        color_count = 1
        next
      end
      color_count = (color == piece.color ? color_count + 1 : 1)
      color = piece.color
      return true if color_count == 4
    end
    return false
  end

  def check_diagonals_game_over
    return check_top_down_diagonals || check_bottom_up_diagonals
  end

  def check_bottom_up_diagonals
    for col in 3..(@@BOARD_WIDTH - 1) do
      return true if check_bottom_up_diagonal(col, @@BOARD_HEIGHT - 1)
    end 
    for row in 3..(@@BOARD_HEIGHT - 2) do
      return true if check_bottom_up_diagonal(@@BOARD_WIDTH - 1, row)
    end
    return false
  end

  def check_bottom_up_diagonal(start_col, start_row)
    color = nil
    color_count = 1
    col = start_col
    row = start_row
    
    until col < 0 || row < 0
      piece = @board[col][row]      
      col -= 1
      row -= 1
      unless piece
        color = nil
        color_count = 1
        next
      end
      color_count = (color == piece.color ? color_count + 1 : 1)
      color = piece.color
      return true if color_count == 4
    end

    return false
  end

  def check_top_down_diagonals
    color = nil
    color_count = 1
    for i in 3..(@@BOARD_WIDTH + @@BOARD_HEIGHT - 5) do
      for col in 0..i do
        break if col > @@BOARD_WIDTH - 1
        row = i - col
        piece = @board[col][row]
        unless piece
          color = nil
          color_count = 1
          next
        end
        color_count = (color == piece.color ? color_count + 1 : 1)
        color = piece.color
        return true if color_count == 4        
      end
    end
    return false
  end
end