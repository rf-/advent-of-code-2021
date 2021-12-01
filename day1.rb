input = File.readlines('day1.input').map(&:to_i)

result_1 = input.each_cons(2).count { |a, b| a < b }

puts result_1 # 1665

result_2 = input.each_cons(3).each_cons(2).count { |a, b| a.sum < b.sum }

puts result_2 # 1702
