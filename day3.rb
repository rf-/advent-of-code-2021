require_relative './shared'

input = File.readlines('day3.input').map(&:chomp)

most_common = ->(values) do
  counts = values.tally
  counts.fetch("0", 0) > counts.fetch("1", 0) ? "0" : "1"
end

least_common = ->(values) do
  counts = values.tally
  counts.fetch("1", 0) < counts.fetch("0", 0) ? "1" : "0"
end

# Part 1

bits_by_place = input.map { _1.split("") }.transpose

gamma = bits_by_place.map(&most_common).join("").to_i(2)
epsilon = bits_by_place.map(&least_common).join("").to_i(2)

puts gamma * epsilon # 2583164

# Part 2

values = input
oxygen_rating = (0..).each do |place|
  wanted_bit = most_common.(values.map { _1[place] })
  values = values.filter { _1[place] == wanted_bit }
  break values[0].to_i(2) if values.size == 1
end

values = input
scrubber_rating = (0..).each do |place|
  wanted_bit = least_common.(values.map { _1[place] })
  values = values.filter { _1[place] == wanted_bit }
  break values[0].to_i(2) if values.size == 1
end

puts oxygen_rating * scrubber_rating # 2784375
