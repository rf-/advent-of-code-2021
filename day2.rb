require_relative './shared'

input = File.readlines('day2.input').map do |line|
  line.split.then { [_1, _2.to_i] }
end

# Part 1

position = 0
depth = 0

input.each do |command, count|
  case command
  when "forward"
    position += count
  when "down"
    depth += count
  when "up"
    depth -= count
  end
end

puts position * depth # 1250395

# Part 2

position = 0
depth = 0
aim = 0

input.each do |command, count|
  case command
  when "forward"
    position += count
    depth += aim * count
  when "down"
    aim += count
  when "up"
    aim -= count
  end
end

puts position * depth # 1451210346
