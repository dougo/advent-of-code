# These methods are shamelessly stolen from ActiveSupport!

module Enumerable
  # Convert to a hash, computing the indices with a given block.
  def index_by
    map { |x| [yield(x), x] }.to_h
  end
end

class Object
  def in?(things)
    things.include?(self)
  end
end
