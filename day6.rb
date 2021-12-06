require_relative './shared'

input = File.read('day6.input').strip.split(',').map(&:to_i)

fish_after_days = ->(days) do
  if days < 9
    1
  else
    fish_after_days[days - 6 - 1] + fish_after_days[days - 8 - 1]
  end
end.memoize

all_fish_after_days = ->(days) do
  input.map { fish_after_days.call(days + 8 - _1) }.sum
end

# Part 1

puts all_fish_after_days[80] # 380243

# Part 2

puts all_fish_after_days[256] # 1708791884591
