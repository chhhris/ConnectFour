class Game
  attr_accessor :current_board, :currrent_player, :current_checker, :checker_coordinates

  def initialize(rows: nil, columns: nil)
    @rows =  ENV['DEFAULT_BOARD_ROWS'].to_i
    @columns = ENV['DEFAULT_BOARD_COLUMNS'].to_i
  end

  def new_board
    @columns.times.map { Array.new(@rows, '<>') }
  end

  def update_board(board, column, player)
    current_board, currrent_player = board, player
    current_checker = player == 'player1' ? 'O' : 'X'
    checker_coordinates = drop_checker(column)
    count = count_consecutive_checkers(checker_coordinates)

    if count > 3
      game_over_with_winner!
    else
      return current_board
    end
  end

  private

  def game_over_with_winner!
    # code goes here
  end

  def drop_checker(column)
    # TODO check if board is full
    row = current_board.length - 1
    until(current_board[row][column] == '<>') do
      row -= 1
    end
    current_board[row][column] = checker
    [column, row]
  end

  def count_consecutive_checkers(checker_coordinates)
    # code goes here
  end
end