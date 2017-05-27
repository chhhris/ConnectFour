require_relative 'board'

class Game
  attr_accessor :board, :num_players, :current_player, :current_checker,
      :checker_coordinates, :connect_four, :over

  EMPTY_CELL = 0
  PLAYER1 = 'Player 1'.freeze
  PLAYER2 = 'Player 2'.freeze
  PLAYER1_VALUE = 1
  PLAYER2_VALUE = 2
  COMPUTER = 'Computer'.freeze

  SWITCH_PLAYERS = {
    PLAYER2 => PLAYER1,
    PLAYER1 => PLAYER2
  }.freeze

  TOGGLE_CPU_TURN = {
    COMPUTER => PLAYER1,
    PLAYER1 => COMPUTER
  }.freeze

  def board
    @board ||= Board.new.create_board
  end

  def current_player
    @current_player ||= PLAYER1
  end

  def process_move_and_return_board(current_board, slot, player)
    self.board = current_board
    self.current_player = player

    self.current_checker = current_player == PLAYER1 ? PLAYER1_VALUE : PLAYER2_VALUE
    self.checker_coordinates = drop_checker(slot)

    check_for_game_ending
    board
  end

  def execute_computer_move
    max_offensive_count = 0
    optimal_offensive_slot = 0

    max_defensive_count = 0
    optimal_defensive_slot = 0

    board.first.each_with_index do |cell, slot|
      next unless cell.zero?
      self.checker_coordinates = drop_checker(slot, assign_cell: false)

      self.current_checker = PLAYER2_VALUE
      offense_count = count_of_adjacent_checkers
      if offense_count >= max_offensive_count
        max_offensive_count = offense_count
        optimal_offensive_slot = slot
      end

      self.current_checker = PLAYER1_VALUE
      defense_count = count_of_adjacent_checkers
      if defense_count >= max_defensive_count
        max_defensive_count = defense_count
        optimal_defensive_slot = slot
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

    self.current_checker = PLAYER2_VALUE
    self.checker_coordinates = drop_checker(optimal_slot, assign_cell: true)
    check_for_game_ending
  end

  def check_for_game_ending
    self.connect_four = check_if_connect_four?
    self.over = check_if_board_full?
  end

  def check_if_connect_four?
    count_of_adjacent_checkers >= 3
  end

  def check_if_board_full?
    board.first.all? { |checker| checker != EMPTY_CELL }
  end

  private

  def drop_checker(slot, assign_cell: true)
    row = board.length - 1
    until board[row][slot] == EMPTY_CELL
      return if row < 0
      row -= 1
    end

    board[row][slot] = current_checker if assign_cell
    [slot, row]
  end

  def count_of_adjacent_checkers
    horizontal_count = count_left + count_right
    diagonal_asc_count = count_diagonal_asc_right + count_diagonal_desc_left
    diagonal_desc_count = count_diagonal_desc_right + count_diagonal_asc_left

    [count_down, horizontal_count, diagonal_asc_count, diagonal_desc_count].max
  end

  def row
    checker_coordinates.first
  end

  def column
    checker_coordinates.last
  end

  def count_down
    counter = 0
    move = column + 1
    while move < board.length && board[move][row] == current_checker
      counter += 1
      move += 1
    end
    counter
  end

  def count_left
    counter = 0
    move = row - 1
    while move >= 0 && board[column][move] == current_checker
      counter += 1
      move -= 1
    end
    counter
  end

  def count_right
    counter = 0
    move = row + 1
    while move < board.first.length && board[column][move] == current_checker
      counter += 1
      move += 1
    end
    counter
  end

  # Diagonal ASC
  def count_diagonal_asc_right
    counter = 0
    vertical = column - 1
    horizontal = row + 1
    while vertical >= 0 && horizontal < board.first.length && board[vertical][horizontal] == current_checker
      counter += 1
      vertical -= 1
      horizontal += 1
    end
    counter
  end

  def count_diagonal_desc_left
    counter = 0
    vertical = column + 1
    horizontal = row - 1
    while vertical < board.length && horizontal >= 0 && board[vertical][horizontal] == current_checker
      counter += 1
      vertical += 1
      horizontal -= 1
    end
    counter
  end

  # Diagonal DESC
  def count_diagonal_desc_right
    counter = 0
    vertical = column + 1
    horizontal = row + 1
    while vertical < board.length && horizontal < board.first.length && board[vertical][horizontal] == current_checker
      counter += 1
      vertical += 1
      horizontal += 1
    end
    counter
  end

  def count_diagonal_asc_left
    counter = 0
    vertical = column - 1
    horizontal = row - 1
    while vertical >= 0 && horizontal >= 0 && board[vertical][horizontal] == current_checker
      counter += 1
      vertical -= 1
      horizontal -= 1
    end
    counter
  end
end
