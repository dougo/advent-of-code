# These methods are shamelessly stolen from ActiveSupport!

module Enumerable
  # Convert to a hash, computing the indices with a given block.
  def index_by
    map { |x| [yield(x), x] }.to_h
  end

  def sum(&block)
    if block_given?
      map(&block).sum
    else
      reduce(:+) || 0
    end
  end
end

class Object
  def in?(things)
    things.include?(self)
  end
end
