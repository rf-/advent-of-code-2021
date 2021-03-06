require 'set'

class Set
  def pop
    return if @hash.empty?
    value = @hash.each { |key, _value| break key } # rubocop:disable Lint/UnreachableLoop
    @hash.delete(value)
    value
  end
end

class Array
  # Generate all combinations of any length (including 0)
  def all_combinations
    (0...(2**length)).map do |mask|
      idx = 0
      result = []
      while mask > 0
        result << self[idx] if mask & 1 == 1
        idx += 1
        mask >>= 1
      end
      result
    end
  end
end

module Enumerable
  # Via https://gist.github.com/havenwood/27a5850b99bb35f855b079038664b120
  def find_map
    return enum_for __method__ unless block_given?

    each do |item|
      found = yield item
      return found if found
    end

    nil
  end
end

class Proc
  def memoize
    cache = {}
    old_call = method(:call)

    singleton_class.define_method :call do |*args, **kwargs|
      if cache.key?([args, kwargs])
        cache[[args, kwargs]]
      else
        value = old_call.call(*args, **kwargs)
        cache[[args, kwargs]] = value
        value
      end
    end

    singleton_class.define_method :clear do
      cache = {}
    end

    singleton_class.alias_method :[], :call

    self
  end
end

class Range
  def &(other)
    if exclude_end? != other.exclude_end?
      raise "Can't intersect closed and open ranges"
    end

    if exclude_end?
      return nil if self.end <= other.begin || other.end <= self.begin
      [self.begin, other.begin].max ... [self.end, other.end].min
    else
      return nil if self.end < other.begin || other.end < self.begin
      [self.begin, other.begin].max .. [self.end, other.end].min
    end
  end
end
