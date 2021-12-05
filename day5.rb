require_relative './shared'

input = File.readlines('day5.input').map do |line|
  line =~ /(\d+),(\d+) -> (\d+),(\d+)/
  [[$1, $2], [$3, $4]].map { _1.map(&:to_i) }
end

count_overlaps = ->(exclude_diagonals) do
  grid = Grid.new(:y_down, default: 0)
  include grid.point_ops
  using grid.point_ops

  input.each do |p1, p2|
    next if exclude_diagonals && p1.bearing(p2) % 90 != 0
    p1.line(p2).each { |x, y| grid[x, y] += 1 }
  end

  grid.select { |_, val| val >= 2 }.size
end

# Part 1

puts count_overlaps.(true) # 5442

# Part 2

puts count_overlaps.(false) # 19571
