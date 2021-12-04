require_relative './shared'

numbers_line, *other_lines = File.readlines('day4.input').map(&:chomp)

boards = other_lines.each_slice(6).map do |lines|
  lines.drop(1).map { _1.split.map(&:to_i) }
end

scores = []

numbers_line.split(",").map(&:to_i).each do |number|
  next_boards = []

  boards.each do |board|
    board = board.map do |row|
      row.map { |value| value == number ? "x" : value }
    end

    if (
      board.any? { |row| row.all? { |val| val == "x" } } ||
      board.transpose.any? { |col| col.all? { |val| val == "x" } } ||
      board.each_with_index.all? { |row, idx| row[idx] == "x" } ||
      board.each_with_index.all? { |row, idx| row[4 - idx] == "x" }
    )
      scores << (board.flatten.grep(Integer).sum * number)
    else
      next_boards << board
    end
  end

  boards = next_boards
end

# Part 1

puts scores[0] # 16674

# Part 2

puts scores[-1] # 7075
