class Board

  def create_board
    rows.times.map { Array.new(columns, 0) }
  end

  def rows
    ENV['DEFAULT_BOARD_ROWS'].to_i
  end

  def columns
    ENV['DEFAULT_BOARD_COLUMNS'].to_i
  end

end
