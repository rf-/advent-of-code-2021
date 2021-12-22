require_relative './shared'

split_range = ->(range_1, range_2) do
  overlap = range_1 & range_2
  return if overlap.nil?
  [
    range_1.begin < overlap.begin ? range_1.begin .. (overlap.begin - 1) : nil,
    overlap,
    range_1.end > overlap.end ? (overlap.end + 1) .. range_1.end : nil,
  ]
end

count_cubes = ->(cuboids) do
  cuboids.map { |axes| axes.map(&:size).reduce(:*) }.reduce(:+)
end

steps = File.readlines('day22.input').map do |line|
  x_min, x_max, y_min, y_max, z_min, z_max = line.scan(/-?\d+/).map(&:to_i)
  [
    line.start_with?("on"),
    x_min .. x_max,
    y_min .. y_max,
    z_min .. z_max,
  ]
end

cuboids = []

steps.each do |turn_on, step_xs, step_ys, step_zs|
  next_cuboids = []

  cuboids.each do |target_xs, target_ys, target_zs|
    x_parts = split_range.(target_xs, step_xs)
    y_parts = split_range.(target_ys, step_ys)
    z_parts = split_range.(target_zs, step_zs)

    if x_parts && y_parts && z_parts
      x_parts.product(y_parts, z_parts).each do |xs, ys, zs|
        next if xs == x_parts[1] && ys == y_parts[1] && zs == z_parts[1]
        next unless xs && ys && zs
        next_cuboids << [xs, ys, zs]
      end
    else
      next_cuboids << [target_xs, target_ys, target_zs]
    end
  end

  if turn_on
    next_cuboids << [step_xs, step_ys, step_zs]
  end

  cuboids = next_cuboids
end

# Part 1

sliced_cuboids = cuboids.filter_map do |axes|
  sliced_axes = axes.map { _1 & (-50..50) }
  sliced_axes unless sliced_axes.any?(&:nil?)
end

puts count_cubes.(sliced_cuboids) # 561032

# Part 2

puts count_cubes.(cuboids) # 1322825263376414
