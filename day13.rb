require_relative './shared'

raw_coords, raw_folds = File.read('day13.input').strip.split("\n\n")

coords = raw_coords.lines.map { _1.scan(/\d+/).map(&:to_i) }

folds = raw_folds.lines.map { _1 =~ /([xy])=(\d+)/ && [$1, $2.to_i] }

grid = Grid.new(:y_down)
coords.each do |x, y|
  grid[x, y] = '#'
end

fold = ->(grid_, (axis, n)) do
  grid_.transform_keys do |(x, y),|
    axis == 'x' ? [x > n ? (2 * n) - x : x, y] : [x, y > n ? (2 * n) - y : y]
  end
end

# Part 1

puts fold.(grid, folds[0]).size # 850

# Part 2

folds.each { grid = fold.(grid, _1) }

puts grid.visualize { _1 || '.' } # AHGCPGAU
