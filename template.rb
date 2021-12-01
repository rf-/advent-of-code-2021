require_relative './shared'

example_input = nil
# example_input = <<EOS
# EOS

input = (example_input || File.read('dayN.input')).strip
# or
input = (example_input || File.read('dayN.input')).strip.lines.map(&:chomp)

Pry.start(binding, quiet: true)

# grid = Grid.new(:y_down OR :y_up)
# include grid.point_ops
# using grid.point_ops

# GraphUtils.topo_sort([[dependency, dependent], ...])
