# frozen_string_literal: true

require_relative '../lib/game_match'
require_relative '../lib/player'
describe GameMatch do
  
  describe '#initialize' do
  end

  describe '#run_game' do
  end

  describe '#display_welcome' do
  end

  describe '#play_turn' do
  end

  subject(:game_match) { described_class.new }
  describe '#make_move' do
    context 'empty board' do
      before do
        allow(game_match).to receive(:verified_input).and_return(3)
      end
      
      it 'player 1 makes move' do
        game_match.make_move
        result = [
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 1, 0, 0, 0]
        ]
        expect(game_match.instance_variable_get(:@game_board)).to eq(result)
      end
    end
    
    context 'middle of the game' do
      before do
        game_match.instance_variable_set(:@game_board, [
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 2, 0, 0],
          [0, 1, 1, 1, 2, 0, 0]
        ])
        game_match.instance_variable_set(:@next_turn,2)
        allow(game_match).to receive(:verified_input).and_return(2)
      end
      it 'change game board' do
        game_match.make_move
        result = [
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 2, 0, 2, 0, 0],
          [0, 1, 1, 1, 2, 0, 0]
        ]
        expect(game_match.instance_variable_get(:@game_board)).to eq(result)
      end
    end   
  end

  

  describe '#verified_input' do
    let(:player) {instance_double(Player)}
    context 'game board is empty. error message twice' do
      before do
        allow(player).to receive(:input_col).and_return(11,-1,3)
      end
      it 'error message once' do
        error_mess = 'Input error! Input a number from 0 to 6'
        expect(game_match).to receive(:puts).with(error_mess).twice
        game_match.verified_input(player)
      end
    end

    context 'game board is full column 1' do
      before do
        game_match.instance_variable_set(:@game_board, [
          [0, 2, 0, 0, 0, 0, 0],
          [0, 1, 0, 0, 0, 0, 0],
          [0, 2, 0, 0, 0, 0, 0],
          [0, 1, 0, 0, 0, 0, 0],
          [0, 2, 0, 0, 2, 0, 0],
          [0, 1, 1, 1, 2, 0, 0]
        ])
        allow(player).to receive(:input_col).and_return(11,1,3)
      end
      it 'receive 2 error messages' do
        error_mess_2 = 'Input error! Column is already full!'
        error_mess_1 = 'Input error! Input a number from 0 to 6'
        expect(game_match).to receive(:puts).with(error_mess_1).ordered
        expect(game_match).to receive(:puts).with(error_mess_2).ordered
        game_match.verified_input(player)
      end
    end
  end

  describe '#check_col_available' do
    context 'game board is empty. error message twice' do
      before do
        game_match.instance_variable_set(:@game_board, [
          [0, 2, 0, 0, 2, 0, 0],
          [0, 1, 0, 0, 1, 0, 0],
          [0, 2, 0, 0, 2, 0, 0],
          [0, 1, 0, 0, 1, 0, 0],
          [0, 2, 0, 1, 2, 0, 0],
          [0, 1, 1, 1, 2, 0, 0]
        ])
      end
      it 'check column 4 not available' do
        expect(game_match.check_col_available(4)).to be false
      end
      it 'check column 3 available' do
        expect(game_match.check_col_available(3)).to be true
      end
      it 'check column 1 not available' do
        expect(game_match.check_col_available(1)).to be false
      end
    end
  end

  describe '#check_row' do
    context 'game board player 1 win' do
      before do
        game_match.instance_variable_set(:@game_board, [
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 1, 1, 1, 1, 0, 0],
          [0, 2, 2, 2, 1, 0, 0],
          [0, 1, 2, 1, 2, 2, 0]
        ])
      end
      it 'check row 3 return 1' do
        expect(game_match.check_row(3)).to eq(1)
      end
      it 'check column 2 return nil' do
        expect(game_match).to receive(:check_row).with(2).and_return(nil)
        game_match.check_row(2)
      end
      it 'check column 1 return nil' do
        expect(game_match).to receive(:check_row).with(1).and_return(nil)
        game_match.check_row(1)
      end
    end
  end

  describe '#check_row' do
    context 'game board player 2 win' do
      before do
        game_match.instance_variable_set(:@game_board, [
          [0, 0, 0, 0, 2, 0, 0],
          [0, 0, 0, 1, 2, 0, 0],
          [0, 0, 0, 1, 2, 0, 0],
          [0, 0, 1, 1, 2, 0, 0],
          [1, 1, 2, 2, 1, 2, 0],
          [1, 1, 2, 1, 2, 2, 0]
        ])
      end
      it 'check col 4 return 2' do
        expect(game_match.check_col(4)).to eq(2)
      end
      it 'check column 3 return nil' do
        expect(game_match).to receive(:check_col).with(3).and_return(nil)
        game_match.check_col(3)
      end
      it 'check column 0 return nil' do
        expect(game_match).to receive(:check_col).with(0).and_return(nil)
        game_match.check_col(0)
      end
    end
  end

  describe '#check_diag' do
    context 'game board player 2 win' do
      before do
        game_match.instance_variable_set(:@game_board, [
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [1, 0, 0, 0, 1, 1, 0],
          [2, 0, 0, 1, 2, 2, 0],
          [2, 2, 1, 2, 1, 2, 0],
          [2, 1, 2, 1, 1, 1, 2]
        ])
      end
      it 'check row 2 col 4 return 1' do
        expect(game_match.check_diag(2,4)).to eq(1)
      end
      it 'check row 5 col 1 return nil' do
        expect(game_match).to receive(:check_diag).with(5,1).and_return(nil)
        game_match.check_diag(5,1)
      end
    end
  end

  describe '#check_end_game' do
    context 'No one win' do
      before do
        game_match.instance_variable_set(:@game_board, [
          [1, 2, 1, 2, 1, 1, 2],
          [1, 2, 1, 2, 1, 2, 1],
          [1, 2, 1, 2, 1, 1, 2],
          [2, 1, 2, 1, 2, 2, 1],
          [2, 1, 2, 2, 1, 1, 2],
          [1, 2, 2, 2, 1, 1, 2]
        ])
        game_match.instance_variable_set(:@added_loc, [0,6])
      end
      it 'expect game ends with no winner' do
        game_match.check_end_game
        expect(game_match.instance_variable_get(:@winner)).to be nil
        expect(game_match.instance_variable_get(:@is_finish)).to be true
      end
    end

    context 'Player 1 win' do
      before do
        game_match.instance_variable_set(:@game_board, [
          [0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0],
          [1, 0, 0, 0, 1, 1, 0],
          [2, 0, 0, 1, 2, 2, 0],
          [2, 2, 1, 2, 1, 2, 0],
          [2, 1, 2, 1, 1, 1, 2]
        ])
        game_match.instance_variable_set(:@added_loc, [2,4])
      end
      it 'expect game ends with no winner' do
        game_match.check_end_game
        expect(game_match.instance_variable_get(:@winner)).to eq(1)
        expect(game_match.instance_variable_get(:@is_finish)).to be true
      end
    end
  end
end
