require_relative './shared'

input = File.readlines('day8.input').map do |line|
  line.chomp.split('|').map { |half| half.split.map { _1.chars.to_set } }
end

digits = %w[
  abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg
].map { _1.chars.to_set }

# Each char has a distinct "signature" of digit lengths it appears in
key_for_char = ->(char, signals) do
  signals.select { _1.include?(char) }.map(&:length).tally
end

real_char_by_key = ("a".."g").index_by { |char| key_for_char.(char, digits) }

all_outputs = input.map do |(signals, outputs)|
  real_char_by_signal_char = ("a".."g").map do |char|
    [char, real_char_by_key[key_for_char.(char, signals)]]
  end.to_h

  outputs.map do |output|
    digits.index(output.map { real_char_by_signal_char[_1] }.to_set)
  end
end

# Part 1

puts all_outputs.flatten.count { [1, 4, 7, 8].include?(_1) } # 548

# Part 2

puts all_outputs.map { _1.join.to_i }.sum # 1074888
