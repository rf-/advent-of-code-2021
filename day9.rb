require_relative './shared'

input = File.readlines('day9.input').map(&:chomp)

grid = Grid.new(:y_down, mode: :orthogonal, default: 9).fill(input, &:to_i)

# Part 1

low_points = grid.select do |coords, value|
  grid.neighbors(*coords).all? { |n| value < n }
end

puts low_points.values.sum + low_points.size # 465

# Part 2

visited = Set.new()
basins = []

grid.each do |point, value|
  next if visited.include?(point)
  visited.add(point)
  next if value == 9

  basin_size = 1

  to_visit = grid.neighbor_coords(*point).to_set
  while to_visit.size > 0
    current_point = to_visit.pop
    visited.add(current_point)
    next if grid[*current_point] == 9

    basin_size += 1

    grid.neighbor_coords(*current_point).each do |neighbor|
      next if visited.include?(neighbor)
      to_visit.add(neighbor)
    end
  end

  basins.push(basin_size)
end

puts basins.max(3).reduce(:*) # 1269555
