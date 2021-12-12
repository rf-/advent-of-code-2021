require_relative './shared'

input = File.readlines('day12.input')

graph = Hash.new { |h, k| h[k] = Set.new }

input.each do |line|
  cave_1, cave_2 = line.chomp.split('-')
  graph[cave_2].add(cave_1)
  graph[cave_1].add(cave_2)
end

small_caves = graph.keys.filter { |k| k.downcase == k }.to_set

# Part 1

paths_to_end_1 = ->(current_cave, path_so_far, seen_caves) do
  return 1 if current_cave == 'end'

  if small_caves.include?(current_cave) && !seen_caves.include?(current_cave)
    seen_caves = seen_caves.dup.add(current_cave)
  end

  choices = (graph[current_cave] - seen_caves)
  updated_path = path_so_far + [current_cave]

  choices.sum do |next_cave|
    paths_to_end_1.(next_cave, updated_path, seen_caves)
  end
end

result_1 = paths_to_end_1.('start', [], Set.new(['start']))

puts result_1 # 5076

# Part 2

paths_to_end_2 = ->(current_cave, path_so_far, seen_once, seen_twice) do
  return 1 if current_cave == 'end'

  if seen_once.include?(current_cave)
    seen_once = seen_once.dup.delete(current_cave)
    seen_twice = seen_twice.dup.add(current_cave)
  elsif !seen_twice.include?(current_cave) && small_caves.include?(current_cave)
    seen_once = seen_once.dup.add(current_cave)
  end

  choices =
    if seen_twice.size == 1
      graph[current_cave] - seen_twice
    else
      graph[current_cave] - seen_twice - seen_once
    end

  updated_path = path_so_far + [current_cave]

  choices.sum do |next_cave|
    paths_to_end_2.(next_cave, updated_path, seen_once, seen_twice)
  end
end

result_2 = paths_to_end_2.('start', [], Set.new, Set.new(['start']))

puts result_2 # 145643
