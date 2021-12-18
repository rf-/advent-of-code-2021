require_relative './shared'

input = File.read('day18.input').strip.lines.map(&:chomp).map { eval(_1) }

flatten_expr = ->(expr, level = -1) do
  if Numeric === expr
    [[expr, level]]
  else
    expr.flat_map { flatten_expr.(_1, level + 1) }
  end
end

each_leaf_pair = ->(expr, &block) do
  expr.each_cons(2).each_with_index do |(left, right), idx|
    block.call([left[0], right[0], left[1], idx]) if left[1] == right[1]
  end
end

explode = ->(expr) do
  each_leaf_pair.(expr) do |val_1, val_2, nesting, idx|
    next unless nesting == 4

    expr = expr.dup
    if idx > 0
      prev_val, prev_nesting = expr[idx - 1]
      expr[idx - 1] = [prev_val + val_1, prev_nesting]
    end
    if idx < expr.length - 2
      next_val, next_nesting = expr[idx + 2]
      expr[idx + 2] = [next_val + val_2, next_nesting]
    end
    expr[idx .. idx + 1] = [[0, 3]]
    return expr
  end

  nil
end

split = ->(expr) do
  expr.each_with_index do |(val, nesting), idx|
    if val >= 10
      expr = expr.dup
      expr[idx..idx] = [
        [(val / 2.0).floor, nesting + 1],
        [(val / 2.0).ceil, nesting + 1],
      ]
      return expr
    end
  end

  nil
end

reduce = ->(expr) do
  loop do
    exploded_expr = explode.(expr)
    next (expr = exploded_expr) if exploded_expr

    split_expr = split.(expr)
    next (expr = split_expr) if split_expr

    break
  end

  expr
end

magnitude = ->(expr) do
  loop do
    each_leaf_pair.(expr) do |val_1, val_2, nesting, idx|
      expr = expr.dup
      expr[idx .. idx + 1] = [[(val_1 * 3) + (val_2 * 2), nesting - 1]]
      break
    end

    return expr[0][0] if expr.length == 1
  end
end

add = ->(a, b) do
  reduce.([*a, *b].map { [_1, _2 + 1] })
end

exprs = input.map(&flatten_expr)

# Part 1

puts magnitude.(exprs.reduce(&add)) # 3647

# Part 2

puts exprs.permutation(2).map { magnitude.(add.(_1, _2)) }.max # 4600
