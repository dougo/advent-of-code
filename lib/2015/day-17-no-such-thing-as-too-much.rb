require_relative '../util'

class EggnogContainers
  def initialize(input)
    @sizes = input.split.map &:to_i
  end

  attr_reader :sizes

  def ways_to_fit(eggnog)
    ways_to_fit_by_length(eggnog).reduce(:concat)
  end

  def efficient_ways_to_fit(eggnog)
    ways_to_fit_by_length(eggnog).find { |ways| ways.any? }
  end

  private

  def ways_to_fit_by_length(eggnog)
    (1..sizes.length).lazy.map do |i|
      sizes.combination(i).select { |c| c.sum == eggnog }
    end
  end
end

if defined? DATA
  input = DATA.read
  containers = EggnogContainers.new(input)
  p containers.ways_to_fit(150).length
  p containers.efficient_ways_to_fit(150).length

  require 'benchmark'
  doubled_containers = EggnogContainers.new(input + input)
  t = Benchmark.realtime { p doubled_containers.efficient_ways_to_fit(150).length }
  puts "#{doubled_containers.sizes.length} containers took #{'%.2f' % t}s"
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
