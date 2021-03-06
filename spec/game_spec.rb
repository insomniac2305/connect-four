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

      it 'has the active color set to green' do
        active_color = game_new.instance_variable_get(:@active_color)
        expect(active_color).to eq 'green'
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
    context 'when game board is empty' do
      subject(:game_empty) { described_class.new }

      it 'is not game over' do
        expect(game_empty).not_to be_game_over
      end
    end

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

    context 'when 4 same color pieces are next to each other in a top-down diagonal' do
      subject(:game_over_top_down_diagonal) { described_class.new }
      let(:piece_red) { double('piece', color: 'red') }
      let(:piece_green) { double('piece', color: 'green') }

      before do
        game_over_top_down_diagonal.push_piece(piece_green, 2)
        game_over_top_down_diagonal.push_piece(piece_green, 2)
        game_over_top_down_diagonal.push_piece(piece_red, 2)
        game_over_top_down_diagonal.push_piece(piece_green, 2)

        game_over_top_down_diagonal.push_piece(piece_green, 3)
        game_over_top_down_diagonal.push_piece(piece_red, 3)
        game_over_top_down_diagonal.push_piece(piece_green, 3)
        
        game_over_top_down_diagonal.push_piece(piece_red, 4)
        game_over_top_down_diagonal.push_piece(piece_green, 4)
        
        game_over_top_down_diagonal.push_piece(piece_green, 5)
      end

      it 'is game over' do
        expect(game_over_top_down_diagonal).to be_game_over
      end
    end

    context 'when 4 same color pieces are next to each other in a bottom-up diagonal' do
      subject(:game_over_bottom_up_diagonal) { described_class.new }
      let(:piece_red) { double('piece', color: 'red') }
      let(:piece_green) { double('piece', color: 'green') }

      before do
        game_over_bottom_up_diagonal.push_piece(piece_red, 2)
        game_over_bottom_up_diagonal.push_piece(piece_green, 2)
        game_over_bottom_up_diagonal.push_piece(piece_green, 2)

        game_over_bottom_up_diagonal.push_piece(piece_green, 3)
        game_over_bottom_up_diagonal.push_piece(piece_red, 3)
        game_over_bottom_up_diagonal.push_piece(piece_red, 3)
        
        game_over_bottom_up_diagonal.push_piece(piece_green, 4)
        game_over_bottom_up_diagonal.push_piece(piece_red, 4)
        game_over_bottom_up_diagonal.push_piece(piece_red, 4)

        game_over_bottom_up_diagonal.push_piece(piece_green, 5)
        game_over_bottom_up_diagonal.push_piece(piece_green, 5)
        game_over_bottom_up_diagonal.push_piece(piece_green, 5)
        game_over_bottom_up_diagonal.push_piece(piece_red, 5)
      end

      it 'is game over' do
        expect(game_over_bottom_up_diagonal).to be_game_over
      end
    end

    context 'when there are no 4 same color pieces arranged in a row, column or diagonal' do
      subject(:game_not_over) { described_class.new }
      let(:piece_red) { double('piece', color: 'red') }
      let(:piece_green) { double('piece', color: 'green') }

      before do
        game_not_over.push_piece(piece_green, 0)
        game_not_over.push_piece(piece_red, 0)

        game_not_over.push_piece(piece_red, 2)
        game_not_over.push_piece(piece_green, 2)
        game_not_over.push_piece(piece_green, 2)
        game_not_over.push_piece(piece_red, 2)
        game_not_over.push_piece(piece_green, 2)

        game_not_over.push_piece(piece_green, 3)
        game_not_over.push_piece(piece_red, 3)
        game_not_over.push_piece(piece_red, 3)
        game_not_over.push_piece(piece_green, 3)
        game_not_over.push_piece(piece_red, 3)
        game_not_over.push_piece(piece_red, 3)
        
        game_not_over.push_piece(piece_green, 4)
        game_not_over.push_piece(piece_red, 4)
        game_not_over.push_piece(piece_red, 4)
        game_not_over.push_piece(piece_red, 4)
        game_not_over.push_piece(piece_green, 4)

        game_not_over.push_piece(piece_green, 5)
        game_not_over.push_piece(piece_green, 5)
        game_not_over.push_piece(piece_green, 5)
        
        game_not_over.push_piece(piece_red, 6)
        game_not_over.push_piece(piece_red, 6)
        game_not_over.push_piece(piece_red, 6)
        game_not_over.push_piece(piece_green, 6)
      end

      it 'is not game over' do
        expect(game_not_over).not_to be_game_over
      end
    end
  end

  describe '#board_full?' do
    context 'when the game board is empty' do
      subject(:game_empty) { described_class.new }

      it 'is not full' do
        expect(game_empty).not_to be_board_full
      end
    end

    context 'when the game board is partially filled' do
      subject(:game_partially_filled) { described_class.new }
      let(:piece_red) { double('piece', color: 'red') }
      let(:piece_green) { double('piece', color: 'green') }

      before do
        game_partially_filled.push_piece(piece_green, 0)
        game_partially_filled.push_piece(piece_red, 0)        
        game_partially_filled.push_piece(piece_green, 1)
        game_partially_filled.push_piece(piece_red, 1)
        game_partially_filled.push_piece(piece_green, 2)
        game_partially_filled.push_piece(piece_red, 3)
        game_partially_filled.push_piece(piece_green, 2)
        game_partially_filled.push_piece(piece_red, 3)
        game_partially_filled.push_piece(piece_green, 5)
      end

      it 'is not full' do
        expect(game_partially_filled).not_to be_board_full
      end
    end

    context 'when the game board is full' do
      subject(:game_full) { described_class.new }
      let(:piece_red) { double('piece', color: 'red') }
      let(:piece_green) { double('piece', color: 'green') }

      before do
        for col in 0..6 do
          6.times { game_full.push_piece(piece_green, col)}
        end
      end

      it 'is full' do
        expect(game_full).to be_board_full
      end
    end
  end

  describe '#get_input' do
    subject(:game_input) { described_class.new }

    context 'when input is valid' do
      let(:input) { '2' }
      
      before do
        allow(game_input).to receive(:gets).and_return(input)
      end

      it 'returns input value as integer' do
        result = game_input.get_input
        expect(result).to eq(input.to_i)
      end
    end

    context 'when first input is not a number, second is out of range and third input is valid' do
      let(:input_nan) { 'abc' }
      let(:input_oor) { '10' }
      let(:input_valid) { '3' }

      before do
        allow(game_input).to receive(:puts).with('Wrong input!')
      end
      
      it 'asks for input thrice' do
        allow(game_input).to receive(:gets).and_return(input_nan, input_oor, input_valid)
        expect(game_input).to receive(:gets).thrice
        game_input.get_input
      end

      it 'returns third input value as integer' do
        allow(game_input).to receive(:gets).and_return(input_nan, input_oor, input_valid)
        result = game_input.get_input
        expect(result).to eq(input_valid.to_i)
      end
    end
  end

  describe '#switch_active_color' do
    subject(:game_color) { described_class.new }

    context 'when color was green (new game)' do
      it 'is now red' do
        game_color.switch_active_color
        active_color = game_color.instance_variable_get(:@active_color)
        expect(active_color).to eq 'red'
      end
    end
  end
end