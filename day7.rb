require_relative './shared'

input = File.read('day7.input').split(',').map(&:to_i)

# Part 1

result_1 = (input.min..input.max).map do |t|
  input.sum { (_1 - t).abs }
end.min

puts result_1 # 355989

# Part 2

triangular_number = ->(n) { n * (n + 1) / 2 }

result_2 = (input.min..input.max).map do |t|
  input.sum { triangular_number.((_1 - t).abs) }
end.min

puts result_2 # 102245489
