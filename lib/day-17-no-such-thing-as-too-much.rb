def fit(eggnog, containers)
  return [[]] if eggnog == 0
  return [] if containers.empty?
  container, *rest = containers
  leftover = eggnog - container
  combos = fit(eggnog, rest)
  if leftover >= 0
    combos += fit(leftover, rest).map { |combo| [container, *combo] }
  end
  combos
end

if defined? DATA
  containers = DATA.read.split.map &:to_i
  combos = fit(150, containers)
  p combos.length
  p combos.sort_by(&:length).chunk(&:length).first[1].length
end

__END__
43
3
4
10
21
44
4
6
47
41
34
17
17
44
36
31
46
9
27
38
