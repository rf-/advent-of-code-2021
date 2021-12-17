require_relative './shared'

x_low, x_high, y_low, y_high = File.read('day17.input').scan(/-?\d+/).map(&:to_i)

check_velocity = ->(dx, dy) do
  x, y = 0, 0
  peak_y = 0

  loop do
    return nil if y < y_low
    x += dx
    y += dy
    peak_y = y if y > peak_y
    dx -= 1 if dx > 0
    dy -= 1
    return peak_y if x >= x_low && x <= x_high && y >= y_low && y <= y_high
  end
end

best_y = 0
count = 0

(18..202).each do |x|
  (-110..109).each do |y|
    peak_y = check_velocity.(x, y)
    if peak_y
      count += 1
      best_y = peak_y if peak_y > best_y
    end
  end
end

# Part 1

puts best_y # 5995

# Part 2

puts count # 3202
