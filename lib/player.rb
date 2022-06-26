# frozen_string_literal: true

class Player
  attr_accessor :player_name, :symbol, :code

  def initialize(player_name, code, symbol)
    @player_name = player_name
    @code = code
    @symbol = symbol
  end

  def input_col
    print "#{@player_name} (#{@symbol}) nhap cot (0-6): "
    gets.chomp.to_i
  end
end
