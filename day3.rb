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

gamma, epsilon = [most_common, least_common].map do |rule|
  bits_by_place.map(&rule).join("").to_i(2)
end

puts gamma * epsilon # 2583164

# Part 2

oxygen, co2 = [most_common, least_common].map do |rule|
  values = input
  (0..).each do |place|
    wanted_bit = rule.(values.map { _1[place] })
    values = values.filter { _1[place] == wanted_bit }
    break values[0].to_i(2) if values.size == 1
  end
end

puts oxygen * co2 # 2784375
