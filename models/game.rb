require_relative 'board'

class Game
  attr_accessor :board, :num_players, :current_player, :current_checker, :checker_coordinates, :connect_four, :over

  PLAYER1 = 'Player 1'
  PLAYER2 = 'Player 2'
  COMPUTER = 'Computer'

  SWITCH_PLAYERS = {
    PLAYER2 => PLAYER1,
    PLAYER1 => PLAYER2
  }

  TOGGLE_CPU_TURN = {
    COMPUTER => PLAYER1,
    PLAYER1 => COMPUTER
  }

  def board
    @board ||= Board.new.create_board
  end

  def current_player
    @current_player ||= PLAYER1
  end

  def process_move_and_return_board(current_board, slot, player)
    self.board = current_board
    self.current_player = player

    # better as instance variables?
    self.current_checker = current_player == PLAYER1 ? 1 : 2
    self.checker_coordinates = drop_checker(slot)

    self.connect_four = check_for_connect_four
    self.over = check_if_board_full
    board
  end

  def execute_computer_move
    max_offensive_count = 0
    optimal_offensive_slot = 0

    max_defensive_count = 0
    optimal_defensive_slot = 0

    board[0].each_with_index do |cell, slot|
      if cell == 0
        self.checker_coordinates = drop_checker(slot, assign_cell: false)

        self.current_checker = 2
        offense_count = count_of_adjacent_checkers

        if offense_count >= max_offensive_count
          max_offensive_count = offense_count
          optimal_offensive_slot = slot
        end

        self.current_checker = 1
        defense_count = count_of_adjacent_checkers

        if defense_count >= max_defensive_count
          max_defensive_count = defense_count
          optimal_defensive_slot = slot
        end
      end
    end

    optimal_slot = begin
      if max_offensive_count > 2
        optimal_offensive_slot
      elsif max_defensive_count >= max_offensive_count
        optimal_defensive_slot
      else
        optimal_offensive_slot
      end
    end

    self.current_checker = 2
    self.checker_coordinates = drop_checker(optimal_slot, assign_cell: true)
    self.connect_four = check_for_connect_four
    self.over = check_if_board_full
  end

  def check_for_connect_four
    count_of_adjacent_checkers >= 3 ? true : false
  end

  def check_if_board_full
    board[0].all? { |checker| checker != 0 } ? true : false
  end

  private

  def drop_checker(slot, assign_cell: true)
    # TODO check if board is full
    row = board.length - 1
    until(board[row][slot] == 0) do
      if row > 0
        row -= 1
      else
        return
      end
    end

    board[row][slot] = current_checker if assign_cell
    [slot, row]
  end

  def count_of_adjacent_checkers
    # TODO verify no need to count up
    # vertical_count = count_down + count_up
    horizontal_count = count_left + count_right
    diagonal_asc_count = count_diagonal_up_and_to_the_right + count_diagonal_down_and_to_the_left
    diagonal_desc_count = count_diagonal_down_and_to_the_right + count_diagonal_up_and_to_the_left

    [ count_down, horizontal_count, diagonal_asc_count, diagonal_desc_count ].max
  end


  # check CHECKER / PLAYER instead of hardcoding 1
  def count_down
    x, y = checker_coordinates[0], checker_coordinates[1]
    counter = 0
    move = y.send(:+, 1)
    while(move < board.length && board[move][x] == current_checker) do
      counter += 1
      move = move.send(:+, 1)
    end
    counter
  end

  # def count_up
  #   x, y = checker_coordinates[0], checker_coordinates[1]
  #   counter = 0
  #   move = y.send(:-, 1)
  #   while(move >= 0 && board[move][x] == current_checker) do
  #     counter += 1
  #     move = move.send(:-, 1)
  #   end
  #   counter
  # end

  def count_left
    x, y = checker_coordinates[0], checker_coordinates[1]
    counter = 0
    move = x.send(:-, 1)
    while(move >= 0 && board[y][move] == current_checker) do
      counter += 1
      move = move.send(:-, 1)
    end
    counter
  end

  def count_right
    x, y = checker_coordinates[0], checker_coordinates[1]
    counter = 0
    move = x.send(:+, 1)
    while(move < board[0].length && board[y][move] == current_checker) do
      counter += 1
      move = move.send(:+, 1)
    end
    counter
  end

  # Diagonal ASC
  def count_diagonal_up_and_to_the_right
    x, y = checker_coordinates[0], checker_coordinates[1]
    counter = 0
    move_up = y.send(:-, 1)
    move_right = x.send(:+, 1)
    while(move_up >= 0 && move_right < board[0].length && board[move_up][move_right] == current_checker) do
      counter += 1
      move_up = move_up.send(:-, 1)
      move_right = move_right.send(:+, 1)
    end
    counter
  end

  def count_diagonal_down_and_to_the_left
    x, y = checker_coordinates[0], checker_coordinates[1]
    counter = 0
    move_down = y.send(:+, 1)
    move_left = x.send(:-, 1)
    while(move_down < board.length && move_left >= 0 && board[move_down][move_left] == current_checker) do
      counter += 1
      move_down = move_down.send(:+, 1)
      move_left = move_left.send(:-, 1)
    end
    counter
  end


  # Diagonal DESC
  def count_diagonal_down_and_to_the_right
    x, y = checker_coordinates[0], checker_coordinates[1]
    counter = 0
    move_down = y.send(:+, 1)
    move_right = x.send(:+, 1)
    while(move_down < board.length && move_right < board[0].length && board[move_down][move_right] == current_checker) do
      counter += 1
      move_down = move_down.send(:+, 1)
      move_right = move_right.send(:+, 1)
    end
    counter
  end

  # PROBLEM *******************************************
  def count_diagonal_up_and_to_the_left
    x, y = checker_coordinates[0], checker_coordinates[1]
    counter = 0
    move_up = y.send(:-, 1)
    move_left = x.send(:-, 1)
    while(move_up >= 0 && move_left >= 0 && board[move_up][move_left] == current_checker) do
      counter += 1
      move_up = move_up.send(:-, 1)
      move_left = move_left.send(:-, 1)
    end
    counter
  end


end

