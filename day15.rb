require_relative './shared'

input = File.read('day15.input').lines.map(&:chomp)

add_to_queue = ->(queue, value, priority) do
  queue.reject! { |(v, _)| v == value }
  queue.insert(queue.index { |(_, p)| p > priority } || -1, [value, priority])
  queue
end

lowest_cost = ->(grid, start, goal) do
  using grid.point_ops

  min_cost = ->(_cell) do
    (goal.x - start.x).abs + (goal.y - start.y).abs
  end

  open_set = [[start, min_cost.(start)]]

  scores = Hash.new { Float::INFINITY }
  scores[[0, 0]] = 0

  while ((current,) = open_set.shift)
    return scores[current] if current == goal

    grid.neighbor_coords(*current).each do |neighbor|
      neighbor_cost = grid[*neighbor]
      next if neighbor_cost.nil?

      tentative_score = scores[current] + neighbor_cost

      if tentative_score < scores[neighbor]
        scores[neighbor] = tentative_score
        add_to_queue.(open_set, neighbor, tentative_score + min_cost.(neighbor))
      end
    end
  end

  nil
end

# Part 1

grid_1 = Grid.new(:y_down, mode: :orthogonal)
grid_1.fill(input, &:to_i)

start_1 = [0, 0]
goal_1 = grid_1.bounds.then { |_, x, _, y| [x, y] }

puts lowest_cost.(grid_1, start_1, goal_1) # 769

# Part 2

width = input[0].length
height = input.length

grid_2 = Grid.new(:y_down, mode: :orthogonal)

(0...5).each do |tile_x|
  (0...5).each do |tile_y|
    grid_2 = grid_2.merge(
      grid_1.transform do |coords, cost|
        [
          [coords.x + (tile_x * width), coords.y + (tile_y * height)],
          ((cost - 1 + tile_x + tile_y) % 9) + 1,
        ]
      end
    )
  end
end

start_2 = [0, 0]
goal_2 = grid_2.bounds.then { |_, x, _, y| [x, y] }

puts lowest_cost.(grid_2, start_2, goal_2) # 2963
