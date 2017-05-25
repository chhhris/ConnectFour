class Board
  attr_accessor :rows, :columns

  def set_board
    rows.times.map { Array.new(columns, 0) }
  end

  def rows
    @rows ||= ENV['DEFAULT_BOARD_ROWS'].to_i
  end

  def columns
    @columns ||= ENV['DEFAULT_BOARD_COLUMNS'].to_i
  end

end
