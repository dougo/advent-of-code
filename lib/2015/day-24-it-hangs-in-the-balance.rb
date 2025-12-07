require_relative '../util'

class String
  def parse_package_weights
    split.map(&:to_i)
  end
end

class Array
  def each_group_by_size
    (1..size).lazy.flat_map { |i| combination(i).lazy }
  end

  def each_group_that_weighs(group_weight)
    # TODO: prove this is never empty? or find counterexample.
    each_group_by_size.select { |group| group.sum == group_weight }
  end

  def smallest_groups_that_weigh(group_weight)
    each_group_that_weighs(group_weight).chunk(&:size).first[1]
  end

  def smallest_group_that_weighs(group_weight)
    smallest_groups_that_weigh(group_weight).min_by { |group| group.reduce(:*) }.sort
  end

  def ideal_sleigh_configuration(num_groups = 3)
    return [reverse] if num_groups == 1
    group = smallest_group_that_weighs(sum / num_groups)
    [group.reverse!] + (self - group).ideal_sleigh_configuration(num_groups - 1)
    # TODO: we don't actually need the ideal config for the remainder, just the first that works.
  end

  def quantum_entanglement
    first.reduce(:*)
  end
end

if defined? DATA
  packages = DATA.read.parse_package_weights
  p packages.ideal_sleigh_configuration.quantum_entanglement
  p packages.ideal_sleigh_configuration(4).quantum_entanglement
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
