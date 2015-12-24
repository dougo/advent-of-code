require_relative 'util'

# First attempt, copied from Day 17. This is too slow for this many inputs. :(
def groups(total, weights)
  return [[]] if total == 0
  return [] if weights.empty?
  weight, *rest = weights
  if weight > total
    groups(total, rest)
  else
    groups(total - weight, rest).map { |group| [*group, weight] } + groups(total, rest)
  end
end

def smallest_group(total, weights)
  (1..weights.length / 2).each do |i|
    weights.combination(i).find do |w| # This only works if the first smallest group has the lowest entanglement...
      return w if w.sum == total
    end
  end
end

def trisections(weights)
  weights = weights.reverse
  total = weights.sum / 3
  center = smallest_group(total, weights)
  left = smallest_group(total, weights - center)
  right = weights - center - left
  [center, center.reduce(:*), left, right]
end

# Sometimes copy-paste is quicker than refactor!
def quadrisections(weights)
  weights = weights.reverse
  total = weights.sum / 4
  center = smallest_group(total, weights)
  left = smallest_group(total, weights - center)
  right = smallest_group(total, weights - center - left)
  trunk = weights - center - left - right
  [center, center.reduce(:*), left, right, center]
end

if defined? DATA
  p trisections((1..5).to_a + (7..11).to_a)
  p quadrisections((1..5).to_a + (7..11).to_a)

  weights = DATA.read.split.map(&:to_i)
  p trisections(weights)
  p quadrisections(weights)
end

__END__
1
2
3
5
7
13
17
19
23
29
31
37
41
43
53
59
61
67
71
73
79
83
89
97
101
103
107
109
113
