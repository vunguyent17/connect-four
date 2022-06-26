# frozen_string_literal: true

require_relative 'player'
class GameMatch
  def initialize
    @player1 = Player.new('Player 1', 1, '⚐')
    @player2 = Player.new('Player 2', 2, '⚑')
    @game_board = Array.new(6) { Array.new(7, 0) }
    @added_loc = []
    @next_turn = 1
    @winner = nil
    @is_finish = false
  end

  def run_game
    display_welcome
    play_turn until @is_finish
    if @winner.nil?
      puts "Board is full. It's a draw"
    else
      puts "Game is over. The winner is player #{@winner}"
    end
  end

  def display_welcome
    puts 'Welcome to Connect Four'
    puts "Player 1 (#{@player1.symbol}) vs Player 2 (#{@player2.symbol})"
    puts 'This is boardgame 7x6'
    display_board
  end

  def play_turn
    make_move
    display_board
    check_end_game
    @next_turn = @next_turn == 1 ? 2 : 1
  end

  def make_move
    who_play = @next_turn == 1 ? @player1 : @player2
    col_num = verified_input(who_play)
    5.downto(0) do |row|
      next unless @game_board[row][col_num].zero?

      @game_board[row][col_num] = who_play.code
      @added_loc = [row, col_num]
      break
    end
    @game_board
  end

  def display_board
    @game_board.each do |row|
      row.each do |code|
        print_val = if code.zero?
                      '_'
                    else
                      code == 1 ? @player1.symbol : @player2.symbol
                    end
        print "#{print_val} "
      end
      puts
    end
  end

  def verified_input(who_play)
    col_num = -1
    loop do
      col_num = who_play.input_col
      return col_num if (0..6).include?(col_num) && check_col_available(col_num)

      if !(0..6).include?(col_num)
        puts 'Input error! Input a number from 0 to 6'
      else
        puts 'Input error! Column is already full!'
      end
    end
  end

  def check_col_available(col)
    @game_board[0][col].zero?
  end

  def check_end_game
    @winner = check_row(@added_loc[0]) || check_col(@added_loc[1]) || check_diag(@added_loc[0], @added_loc[1])
    @is_finish = true unless @winner.nil? && @game_board[0].include?(0)
  end

  def check_row(row)
    row_target = @game_board[row]
    check_array(row_target)
  end

  def check_col(col)
    col_target = []
    0.upto(5) do |row|
      col_target.push(@game_board[row][col])
    end
    check_array(col_target)
  end

  def check_valid_loc(idx)
    (0..5).include?(idx[0]) && (0..6).include?(idx[1])
  end

  def check_diag(row, col)
    diag_i_iii = find_diag(row, col, -1)
    diag_ii_iv = find_diag(row, col, 1)
    check_array(diag_i_iii) || check_array(diag_ii_iv)
  end

  private 
  def check_array(arr)
    count = 0
    0.upto(arr.length - 1) do |idx|
      next if arr[idx] == 0
      if idx.positive? && arr[idx] != arr[idx - 1] 
        count = 1
      else
        count += 1
      end
      return arr[idx] if count == 4 
    end
    nil
  end

  def find_diag(row, col, mode)
    diag_index = [[row, col]]
    loop do
      new_idx = [diag_index[0][0] - 1, diag_index[0][1] - 1 * mode]
      break unless check_valid_loc(new_idx)

      diag_index.unshift(new_idx)
    end
    loop do
      new_idx = [diag_index[-1][0] + 1, diag_index[-1][1] + 1 * mode]
      break unless check_valid_loc(new_idx)

      diag_index.push(new_idx)
    end
    diag_index.map { |index| @game_board[index[0]][index[1]] }
  end
end
