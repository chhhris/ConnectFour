class Game
  attr_accessor :board, :current_board, :currrent_player, :current_checker, :checker_coordinates

  def initialize
    @board = Board.new.set_board
  end

  def update_board(board, column, player)
    self.current_board, self.currrent_player = board, player
    # use constant for player
    self.current_checker = player == 'Player 1' ? 1 : -1
    self.checker_coordinates = drop_checker(column)

    # REMINDER add 1 to count
    # e.g. count_up + count_down + 1
    count = (consecutive_checkers || 0)

    if count > 3 || count < -3
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
    until(current_board[row][column] == 0) do
      if row > 0
        row -= 1
      else
        return # with flash message
      end
    end
    # TO DO make sure x and y coordinates are listed currectly
    current_board[row][column] = current_checker
    [column, row]
  end

  def consecutive_checkers
    x, y = checker_coordinates[0], checker_coordinates[1]

    [ count_consecutive_cells(:horizontally),
      count_consecutive_cells(:vertically),
      count_consecutive_cells(:diagonally_asc),
      count_consecutive_cells(:diagonally_desc) ].max
  end

  OPERANDS = {
    # horizontally: []
  }
  def count_consecutive_cells(direction)
    counter = 0
  end

  # check CHECKER / PLAYER instead of hardcoding 1
  def count_down(grid, x, y, target)
    counter = 0
    move = y.send(:+, 1)
    while(grid[move] && grid[move][x] == target) do
      counter += 1
      move = move.send(:+, 1)
    end
    counter
  end

  def count_up(grid, x, y, target)
    counter = 0
    move = y.send(:-, 1)
    while(grid[move] && grid[move][x] == target) do
      counter += 1
      move = move.send(:-, 1)
    end
    counter
  end

  def count_left(grid, x, y, target)
    counter = 0
    move = x.send(:-, 1)
    while(grid[y][move] && grid[y][move] == target) do
      counter += 1
      move = move.send(:-, 1)
    end
    counter
  end

  def count_right(grid, x, y, target)
    counter = 0
    move = x.send(:+, 1)
    while(grid[y][move] && grid[y][move] == target) do
      counter += 1
      move = move.send(:+, 1)
    end
    counter
  end

  # Diagonal ASC
  def count_diagonal_up_and_to_the_right(grid, x, y, target)
    counter = 0
    move_up = y.send(:-, 1)
    move_right = x.send(:+, 1)
    while(grid[move_up] && grid[move_up][move_right] && grid[move_up][move_right] == target) do
      counter += 1
      move_up = y.send(:-, 1)
      move_right = x.send(:+, 1)
    end
    counter
  end

  def count_diagonal_down_and_to_the_left(grid, x, y, target)
    counter = 0
    move_down = y.send(:+, 1)
    move_left = x.send(:-, 1)
    while(grid[move_down] && grid[move_down][move_left] && grid[move_down][move_left] == target) do
      counter += 1
      move_down = y.send(:-, 1)
      move_left = x.send(:-, 1)
    end
    counter
  end


  # Diagonal DESC
  def count_diagonal_down_and_to_the_right(grid, x, y, target)
    counter = 0
    move_down = y.send(:+, 1)
    move_right = x.send(:+, 1)
    while(grid[move_down] && grid[move_down][move_right] && grid[move_down][move_right] == target) do
      counter += 1
      move_down = y.send(:-, 1)
      move_right = x.send(:+, 1)
    end
    counter
  end


  def count_diagonal_up_and_to_the_left(grid, x, y, target)
    counter = 0
    move_up = y.send(:-, 1)
    move_left = x.send(:-, 1)
    while(grid[move_up] && grid[move_up][move_left] && grid[move_up][move_left] == target) do
      counter += 1
      move_up = y.send(:-, 1)
      move_left = x.send(:-, 1)
    end
    counter
  end


end

