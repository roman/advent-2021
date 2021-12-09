class Board
  def initialize(number_matrix)
    @init = number_matrix.collect { |v| v.collect { |a| a.to_i } }
    @matrix = number_matrix.collect { |v| v.collect { |a| false } }
    @entries = {}
    number_matrix.each_with_index do |v, i|
      v.each_with_index do |a, j|
        n = a.to_i
        @entries[n] ||= []
        @entries[n].push([i, j])
      end
    end
  end

  def scratch(value)
    entry = @entries[value]
    if !entry.nil?
      entry.each do |(i, j)|
        @matrix[i][j] = true
      end
    end
  end

  def bingo_horizontal?
    @matrix.any? { |v| v.all? }
  end

  def bingo_vertical?
    for j in (0..@matrix[0].size)
      all = true
      for i in (0...@matrix.size)
        all = all && @matrix[i][j]
      end
      if all
        return true
      end
    end
    false
  end

  def bingo?
    bingo_vertical? || bingo_horizontal?
  end

  def score
    acc = 0
    @init.each_with_index do |v, i|
      v.each_with_index do |e, j|
        if !@matrix[i][j]
          acc += e
        end
      end
    end
    acc
  end

end

def parse_bingo(lines)
  bingo_board = []
  while true
    begin
      if lines.peek == "\n"
        break
      end
      numbers = lines.next.split(' ')
      bingo_board.push(numbers)
    rescue StopIteration
      break
    end
  end

  bingo_board
end

def parse_input
  bingo_boards = []
  lines = $stdin.readlines.collect
  raffle = lines.next.split(',').collect { |a| a.to_i }

  while lines.peek == "\n"
    lines.next
  end

  while
      bingo_board = parse_bingo(lines)
      if bingo_board.nil?
        break
      end

      bingo_boards.push(Board.new(bingo_board))

      begin
        while lines.peek == "\n"
          lines.next
        end
      rescue StopIteration
          break
      end
  end

  [ raffle, bingo_boards ]
end

def main
  raffle, bingo_boards = parse_input
  last_bingo_board = nil
  last_draw = nil
  raffle.each do |draw|
    bingo_boards.reject! do |board|
      board.scratch(draw)
      result = board.bingo?
      if result
        last_draw = draw
        last_bingo_board = board
      end
      result
    end
  end

  # it could happen we end up with lagging boards that never win
  # in this situation, we print that last registered bingo board
  puts "#{last_draw}; last bingo! #{last_bingo_board.inspect}"
  puts "#{last_bingo_board.score * last_draw}"
end

main
