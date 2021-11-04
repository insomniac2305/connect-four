require_relative '../lib/game'

describe Game do
  
  describe '#new' do
    context 'when new game is created' do
      subject(:game_new) { described_class.new }
  
      it 'has an empty game board with 7 columns' do
        game_board = game_new.instance_variable_get(:@board)
        has_seven_empty_columns = (game_board.size == 7 && game_board.all?(&:empty?))
        expect(has_seven_empty_columns).to be true
      end
    end
  end

  describe '#push_piece' do
    context 'when new piece is pushed to the empty first column' do
      subject(:game_pushed) { described_class.new }
      let(:piece) { double('piece') }
      let(:column) { 0 }

      it 'contains that piece in the first column and row' do
        game_pushed.push_piece(piece, column)
        game_board = game_pushed.instance_variable_get(:@board)
        piece_in_column = game_board[column][0]
        expect(piece_in_column).to be piece
      end

      it 'returns column with that piece in last place' do
        returned_piece = game_pushed.push_piece(piece, column).last
        expect(returned_piece).to be piece
      end
    end

    context 'when more than 6 pieces are pushed to the same column' do
      subject(:game_full_column) { described_class.new }
      let(:piece) { double('piece') }
      let(:column) { 0 }

      before do
        6.times { game_full_column.push_piece(piece, column) }
      end

      it 'does not push any more pieces to the same column' do
        game_full_column.push_piece(piece, column)
        game_board = game_full_column.instance_variable_get(:@board)
        column_size = game_board[column].size
        expect(column_size).to eq(6)
      end

      it 'returns nil' do
        result = game_full_column.push_piece(piece, column)
        expect(result).to be_nil
      end
    end
  end

  describe '#game_over?' do
    context 'when 4 same color pieces are on top of each other in a column' do
      subject(:game_over_column) { described_class.new }
      let(:piece_red) { double('piece', color: 'red') }
      let(:piece_green) { double('piece', color: 'green') }
      let(:column) { 0 }

      before do
        game_over_column.push_piece(piece_green, column)
        4.times { game_over_column.push_piece(piece_red, column) }
      end

      it 'is game over' do
        expect(game_over_column).to be_game_over
      end
    end

    context 'when 4 same color pieces are next to each other in a row' do
      subject(:game_over_row) { described_class.new }
      let(:piece_red) { double('piece', color: 'red') }
      let(:piece_green) { double('piece', color: 'green') }

      before do
        game_over_row.push_piece(piece_green, 0)
        game_over_row.push_piece(piece_red, 1)
        game_over_row.push_piece(piece_green, 2)
        game_over_row.push_piece(piece_green, 3)
        game_over_row.push_piece(piece_green, 4)
        game_over_row.push_piece(piece_green, 5)
      end

      it 'is game over' do
        expect(game_over_row).to be_game_over
      end
    end
  end
end