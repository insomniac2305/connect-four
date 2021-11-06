require_relative '../lib/player'

describe Player do
  subject(:player_one_green) { described_class.new('One', 'Green') }

  context 'when player one is created with green color' do
    it 'has the name one and color green' do
      expect(player_one_green).to have_attributes(name: 'One', color: 'Green')
    end
  end
end