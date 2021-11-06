require_relative '../lib/piece'

describe Piece do
  subject(:piece_green) { described_class.new('green') }

  context 'when piece is created with green color' do
    it 'is green' do
      expect(piece_green).to have_attributes(color: 'green')
    end
  end
end