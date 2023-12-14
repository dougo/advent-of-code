=begin

--- Day 12: Hot Springs ---

There's just one problem - many of the springs have fallen into disrepair, so they're not actually sure which
springs would even be safe to use! Worse yet, their condition records of which springs are damaged (your puzzle
input) are also damaged! You'll need to help them repair the damaged records.

In the giant field just outside, the springs are arranged into rows. For each row, the condition records show every
spring and whether it is operational (.) or damaged (#). This is the part of the condition records that is itself
damaged; for some springs, it is simply unknown (?) whether the spring is operational or damaged.

However, the engineer that produced the condition records also duplicated some of this information in a different
format! After the list of springs for a given row, the size of each contiguous group of damaged springs is listed
in the order those groups appear in the row. This list always accounts for every damaged spring, and each number is
the entire size of its contiguous group (that is, groups are always separated by at least one operational
spring: #### would always be 4, never 2,2).

So, condition records with no unknown spring conditions might look like this:

#.#.### 1,1,3
.#...#....###. 1,1,3
.#.###.#.###### 1,3,1,6
####.#...#... 4,1,1
#....######..#####. 1,6,5
.###.##....# 3,2,1

However, the condition records are partially damaged; some of the springs' conditions are actually unknown (?). For
example:

???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1

Equipped with this information, it is your job to figure out how many different arrangements of operational and
broken springs fit the given criteria in each row.

In the first line (???.### 1,1,3), there is exactly one way separate groups of one, one, and three broken springs
(in that order) can appear in that row: the first three unknown springs must be broken, then operational, then
broken (#.#), making the whole row #.#.###.

The second line is more interesting: .??..??...?##. 1,1,3 could be a total of four different arrangements. The last
? must always be broken (to satisfy the final contiguous group of three broken springs), and each ?? must hide
exactly one of the two broken springs. (Neither ?? could be both broken springs or they would form a single
contiguous group of two; if that were true, the numbers afterward would have been 2,3 instead.) Since each ?? can
either be #. or .#, there are four possible arrangements of springs.

The last line is actually consistent with ten different arrangements! Because the first number is 3, the first and
second ? must both be . (if either were #, the first number would have to be 4 or higher). However, the remaining
run of unknown spring conditions have many different ways they could hold groups of two and one broken springs:

?###???????? 3,2,1
.###.##.#...
.###.##..#..
.###.##...#.
.###.##....#
.###..##.#..
.###..##..#.
.###..##...#
.###...##.#.
.###...##..#
.###....##.#

In this example, the number of possible arrangements for each row is:

???.### 1,1,3 - 1 arrangement
.??..??...?##. 1,1,3 - 4 arrangements
?#?#?#?#?#?#?#? 1,3,1,6 - 1 arrangement
????.#...#... 4,1,1 - 1 arrangement
????.######..#####. 1,6,5 - 4 arrangements
?###???????? 3,2,1 - 10 arrangements

Adding all of the possible arrangement counts together produces a total of 21 arrangements.

For each row, count all of the different arrangements of operational and broken springs that meet the given
criteria. What is the sum of those counts?

=end

class ConditionRecord
  def initialize(text)
    @pattern, groups_text = text.split(' ')
    @groups = groups_text.split(',').map(&:to_i)
  end

  attr :pattern, :groups

  def self.distributions(amount, buckets)
    if buckets == 1
      [[amount]]
    else
      (0..amount).flat_map do |i|
        distributions(amount - i, buckets - 1).map { [i, *_1] }
      end
    end
  end

  def self.all_arrangements(total_length, groups)
    wiggle_room = total_length - groups.sum - (groups.length - 1)
    damaged = groups.map { '#' * _1 }
    distributions(wiggle_room, groups.length + 1).map do |dist|
      leading = '.' * dist[0]
      middles = dist[1...-1].map { '.' * (_1 + 1) }
      trailing = '.' * dist[-1]
      leading + damaged.zip([*middles, trailing]).flatten.join
    end
  end

  def arrangements
    self.class.all_arrangements(pattern.length, groups).filter do |arrangement|
      arrangement.chars.zip(pattern.chars).all? { _1 == _2 || _2 == '?' }
    end
  end

  def number_of_arrangements
    arrangements.length
  end
end

class HotSprings
  def initialize(text)
    @conditions = text.lines.map { ConditionRecord.new _1 }
  end

  attr :conditions

  def sum_of_number_of_arrangements
    conditions.sum(&:number_of_arrangements)
  end
end

if defined? DATA
  springs = HotSprings.new(DATA.read)
  puts springs.sum_of_number_of_arrangements
end

__END__
..??#???##??#?? 4,2,2
.#?????????.?. 9,1
.????#..??#? 4,2
??#.#???#? 2,1,1
?#??.???#?#????? 4,1,1,2,3
.???#???#?#????? 2,3,3,1,2
???.????.#??###? 2,3,6
????#?#?#?.??# 1,6,1
.??????.?##. 1,3
?????.?#??.#????#? 1,1,1,3,2,4
?????##?##. 1,4,2
?#??.?????.# 2,1,2,1
?#??.??##???????? 4,2,3
?#????????##?. 1,1,2,3
??#?????.???. 2,1
.?????#??#?#?#??.. 2,9
???..#.?.?#?????# 2,1,3,1,1
????#????#??#???. 1,3,2,4
##?#..?????? 4,3
#???#?.?.?#?? 6,1,1
??#????#.?. 2,2
????????#??? 2,1,6
#?????#.##???. 5,1,5
?????.???.????#?. 1,1,1,6
.#?????#?..?.. 1,2,2,1
?#??#???.??##?# 7,1,2,1
???.?????.##..??. 1,2,1,2,1
.?????..?#? 3,1
??.#?#?????#?#?. 1,11
??.????????.##??? 3,3
?#????#.????? 1,2,1,1
?##??????#.????? 9,1
????????.# 1,2,1
???????##??#.??. 1,3,4,1,1
#?####????.??????. 9,3,2
??#?#????.#??# 7,4
????###.???#? 6,4
??#????#??. 6,2
?.?#.?###????. 2,5,1
??????#??.??#?#. 5,5
??..??????????#?#?#? 1,6,5
?#??.??#?#??#?.?#. 1,1,1,1,2,2
?.?#?#??.???? 6,2
..?#..???#??##???. 2,7
?.?????#??#???? 1,1,1,6,1
??????###? 1,1,3
.#???.?.?##????#? 3,1,8
#?.????.??..?#?????? 1,1,1,1,8
?.???????#?? 1,4
??.???#?..? 1,4
#.????.?#?#??#.? 1,1,1,7,1
.??????###???## 1,2,3,1,2
#??????..?.? 1,1,1,1
???#??#?#?? 3,5
??????#?????..??#? 3,3,1,1,1
????##??????.?#??#? 1,1,2,1,1,6
.?#?..??????. 2,4
??????.??#? 2,3
??.?#??##????#?????? 1,8,1,1,1
??????????#?? 4,4
????#???#?.? 5,1,1
???????#????#? 5,1,3
????.???#????? 2,7
??#?##????#??????.? 12,1,1,1
????#?????. 4,2
..#??????# 2,2,1
??????#???.????.?? 1,1,1,1,3,1
.???##???????#?? 1,7,4
??.??#?#???????#?.. 1,13
##.?#???.???#???.?#. 2,1,2,7,1
??????#?????.????. 10,2
??.???.??.?????#??? 2,1,1,3,1,1
.??#????.#?????#. 1,2,1,1,1
?##???#???.???#?? 6,1,1,1,1
?.???????##?.#?# 1,1,4,3
?.#???#....#?????? 1,1,2,4,1
?????????? 3,3
.#??..#??..#?#.???? 2,3,3,3
??.??##..????.???? 2,1,2,2,2
..??????#?. 1,1,1
#??????.#?##????#??? 1,3,6,1,1
????#?#??#?#?##???? 2,1,6,2,1,1
???..???#? 1,3
?#??????#..?#??.#? 6,1,2,1,1
?.???????##??..? 2,7,1
????.??.?.?? 3,2
???????#??.?? 9,1
??.?.?.#?..???.#?? 1,1,1,1,1,3
???#?????????#?? 4,9
#.??##?#??..???#??? 1,1,6,4,1
?#????.?###?#???#??. 4,9
#???##?#??#.. 8,2
.#?#?.??#??#.?#???? 4,6,3,1
##?????##??#.??.?.. 12,1
????#??##?#.???#? 4,2,1,5
??.??#???##?? 1,1,5
??#????#.??#???#? 3,3,7
?##???????.??#???#.? 5,2,1,2,2,1
????#??.?#?.? 4,1,1
????.??#??#?#???#.#? 4,10,1,1
?.???#.??#? 1,4,2
??????.????#???#???# 4,2,1,1,3,1
#??#??.#?.#?.?? 1,3,1,1,1
????.?????.????? 3,1,1,1,1
??.?.?#????. 2,1,2
??????????.?#.??#?? 3,4,1,1,3
????#?.?##??? 3,4
?#?.???.??..#? 1,1,2,2
???#?#??#?????#???#? 9,1,3,2
?.???#????. 3,2
?###?#?#?#?#.???? 11,1
?????###??. 2,6
.?#.?#..?. 1,1,1
??????####???????.? 1,6,3
????#??????..#?#??? 1,7,4,1
???#????#.? 3,1
?#.??#????.?#???? 1,7,3,1
#??#.??#???#? 4,7
#???##??.#..???? 7,1,1
?..???##?#???#? 4,1
.?#????????#?.?? 4,5
????.##?#????##??#?? 1,11,1
#??..#.??##????#? 1,1,1,6,2
???##?#?????.??? 1,9,1,1
?.#?????##??.?#?? 3,4,3
??.#??#.#? 1,1,1
.?.???##??#?.##?? 7,4
#?????????? 1,4
???#???.?????. 3,1,3,1
#?#?####???.#??. 10,1,1
?#????.????..# 1,2,2,1
?#?#???#?.#.??#.?? 4,3,1,1,1,1
???##?##?.?????#??. 7,6,1
?????.?#?# 1,2,3
?.??#?#???.?. 1,7
??.???#?#?#?##? 1,7,2
.?#?.????#?? 1,1,3
#?..#??????.??#??? 2,7,5
?.?#?.?.?????????# 3,9
????????#?##???. 1,3,6
????#???##?????#. 14,1
..???????#? 4,1
???.?####??? 1,5,1
.?#???#?#???? 1,7
???#?#.?.?????.??? 4,5
.?#?#?????#??# 4,1,1,1
?.??###.??.??.??# 1,5,1,1,1
?..????.?#.????? 1,1,1,1,3
?#???#??.????.???? 1,1,1,2,1,1
.???????.?#?#???.? 1,1,3,5,1,1
??#?#???.?????#??.? 6,1,1,4
?#?#????#?#????.#?# 4,9,1,1
?#????..?##?????? 4,1,4,1
???.??#??.#?#?? 2,3,3
????#???.??.??#? 1,5,1,1
...?????.#?.? 2,1
?#???#?.?#???.# 1,2,1,2,1
.?#?#??#??##???#?.?? 1,1,7,2,2
?#??.???????.### 1,1,4,1,3
??#?????##??????#? 4,6,1,2
??????#????????##??? 1,1,1,1,1,9
??#?.???#??#??#.?.. 3,8,1
.?????.??? 2,1,1
?#????#???. 1,4
.??#?##???.????##?? 5,1,8
??#???#?#??#?.??? 1,8,2
??.???????#??. 4,4
.??.?#?##???#??# 1,11
??.??????? 1,1,4
??.?#?###????#?#.## 2,5,1,1,1,2
?##???#???. 3,5
.?#???#?##?#?.#? 1,8,1
???????#?#??? 4,5,1
????#??.??? 2,2,1
??????#?##??#? 1,1,5,2
?..###???.??#???? 3,1,6
.????..???# 4,1,1
.?#??#??#?## 1,8
?.???.????#????.? 1,7
???????#??.#?????? 1,7,1,5
#?????###?#?#???? 2,8,1,1
##????????# 2,1,3
???#.????#?###?#???. 1,9
.???.????# 1,5
..#?#?????#?? 3,2,2
?.?..??????????????? 3,6
??#????.??#??? 4,1,3,1
.?##???#?###??#??? 10,2
??.?##???.?#??? 6,2,1
??##?.?#???#???? 3,1,1,1,1
????????????#??????. 7,8
??#.#?.??#?..?#.? 2,2,1,2,2
???.?#?????? 1,2,1
?.##??.???#??? 2,1,3
??.???#??????????# 1,5,1,1,3,1
???.??.?.?? 2,1
???#?##.?????#.? 6,1,1
??.????????? 1,2,2
???#??.##?? 4,2
??#?##?##?.?..??. 10,1,1
???????#?..????????. 2,1,1,8
??.?#?##?? 1,2,1
#??#????.#?? 1,4,1,1
?????.???????????. 2,10
??.????.??? 1,2,2
.?.?#??.??? 4,1
?.?#.#?.?###??##?#.. 1,1,1,4,4
#???#???.?#????#???? 8,2,3,2
..#?#..???. 3,1
?.?????#.?.?.#? 2,1,1,1,1
?.?.???.#???? 1,2,1,1
??##??#.?#.??#??.?.? 5,1,2,1,3,1
??.????????????#??. 2,4
.#??.?#???. 1,2,1
#???.?#?#?????.?? 2,7,2
???????#?### 4,2,3
#?#??.???????????#? 5,1,1,3,2
?????.????? 4,1,2
????.???#?#.. 2,5
?.??#.?.?? 1,1,2
?.?????????#?. 1,1,1,3
.??.??#??? 1,3
.???#?##???.#? 2,5,1,2
??#?????.???##??? 2,2,2,2,1
???#?????.#????? 1,6,3
?##????#??.#??? 5,3,2,1
?.???#????### 1,1,1,6
?.???..??..??? 1,1
????.???????#?#?? 2,12
??????.###..?#??#?? 4,3,5,1
#.?#???????? 1,4,1,1
.?????..#??????. 2,1,1
?#?#??.???##?#?###. 5,7,3
???#?##?#?? 5,1
.?#?..?????#? 3,1,2
???.?????.????.??? 1,5,1,2,1
?????.?##??????? 1,1,3,1,1
?#.???????. 2,1,4
?.#.??????#?#.??? 1,1,5,1
?????.?.??.?#???? 1,1,1,1,1
??.#?.?#?.??.???#?## 1,2,1,1,6
???#??????#?#?##? 1,5,1,1,4
#??.#????##??#??#??# 2,2,11
.????#????#?????? 6,3,2
?#??????.? 2,3,1
?????.??##?.?#???### 4,1,2,8
#??.?.?.##??. 3,1,2
.#?#.??#?. 3,2
?#?#?#??#?.?????? 8,1,2
?..??##.??.??? 3,1
??#?#????.??? 1,5,1,2
??#..????#???# 2,1,3,2
#???##????.#???? 2,7,2
?.??????????##? 1,1,1,4
?#??..??.?##? 2,1,4
???????.?.. 2,2,1
?..?##????? 1,3,1
??????#????????. 7,1,2
???????#..#?#??? 6,3,2
????.?????#????? 3,1,6
???#??.??????#?? 3,2,2,1
#.????#.???#??#??? 1,4,1,7
????####???#?#??? 2,4,2,1,2
???.?..#????#?#???#? 1,1,13
??..?????? 2,1,1
???#?#?#?#??????#??? 1,8,1,1,1,1
?.#.?#???? 1,3
?.##????#????..? 2,6
?...???.#?????###. 1,1,1,1,5
???#????#. 1,1,3
?#??????#?#. 3,1,3
.?#??.#?##??#?# 4,9
?.?#???????? 5,1
?.?#?????##?.??????? 3,3,2
????##???.?????.#?.? 2,6,2,1,1,1
?????.?.###???#.?? 2,1,1,3,3,1
?????.?#??? 2,3
?#??.??????????? 3,2,4
.??..????? 2,2
?#?..?..#?. 3,1,1
.?.#???????#? 6,1
??????.???#?. 4,2
?????#?.?. 2,2
?#?#??.?????? 6,1
??#.?..???. 2,3
?##??#?#??.???##?#? 2,6,6
?#???..??#??#. 4,5
#?#??#?????.??.?#?? 11,1,2,1
????#####?##??.?? 14,1
.?.????.#??#.??.?. 1,2,4,1,1
?.?.???###??.. 1,6
??#??###?.?.? 2,5,1,1
..##?#?#?#? 2,1,3
?????.?#?. 2,3
#??#??#.???#?#.??? 7,1,4,1
??#..????#???#??? 3,3,1,3,1
?#??#??.##???.??#? 7,5,2
?????...???? 3,2,1
.?##?.???.. 2,1
?.##??#??..??? 5,1,3
?????????????#??? 1,1,7,4
.?###?#???? 5,1
?#?..??.?? 2,2
.#??#????#?.??#????? 6,3,2,1,1
.?#?#?#???#.#???. 7,1,1,1
??.????#?. 2,1,2
#????????# 1,1,2
.??.????#???..#..? 5,1
.?#???#?#?? 3,6
?.???#??#????#??# 1,12,1
.#.???.??#? 1,2,2
#?.??????#? 1,3,3
??.#?.??#?##??#?# 1,1,1,7,1
?#?.???#??# 2,5,1
??????#?##?????.# 3,9,1
?????##???#?#?#?#.? 1,12
??.????#?##.#?. 1,7,1
?#?.?##????###?#?.?. 1,12
?????#??#??????? 4,1
.#????#??#??#.? 6,5
.?##?.???. 4,1
??####?.#????##??. 6,2,3
?#?#?##??#???? 10,2
??#???...?#?? 5,2
????????## 6,2
?.#?????###?#??. 1,1,8
.????#?..?? 1,2,1
.?.#??.?#? 1,3,1
??????.??.???#?? 1,3,2,6
?????.???? 1,2,3
????????#?????.? 6,1,2,1
.??????##????#? 1,1,2,3
???..#?#??????.??.#. 2,5,3,1,1
##?#?..??#.. 5,1
?????#???.. 2,1
.?#??.?#??.#???.?#? 1,1,1,1,4,1
#?.#####?.?## 1,5,3
????.#??.????#?#??? 1,1,3,1,8
???.???#?##?? 1,7
????##???.??????#?? 6,7
??????#?.# 2,2,1
?.?###??.?..????? 5,3
??####??????? 4,3
..#??#???? 2,1,1
?.#?.????????? 2,3
?.????.?##???##??.?? 1,1,1,9
#.???.?#??#?#?#.? 1,2,3,5,1
???????##.??????. 1,3,1
?#?????.????? 6,1
#???????#???? 1,1,1,5
.?????#?.? 1,3
??#?#?????? 3,1
?.??????????##?#.? 1,8,5
?.?.??.???.??..? 1,1
#???????.?.??? 7,1,1,1
.?.?.?????? 1,4
?##????????# 3,1,1,2
.#????##.?? 2,4,1
?????#????? 1,4
??###?.?.?? 5,1
##?#??.?#? 4,2
?#?#?????#?? 2,4,3
????...????.? 2,1
?.??????#???# 1,3,2,3
???.?.?????? 1,1,4
?#?#??#???????????? 5,2,8
????????#.?.?? 7,2
.?.?????.??. 5,1
?.??????..? 1,2,1
?#?#??##?.??????. 2,1,3,4
??????.???#?? 5,1,1
??#####?.??.??#??? 8,2
.??.????#????#??. 1,12
??##???#????##?# 3,1,1,3,1
??##????#?..?? 3,2,1
??#??#??#??.??? 10,1,1
..?#?#.#???.?.#. 4,4,1
..??##?.?.? 4,1
.?#.????#.? 1,3
?#????????. 5,1
??.?????.#.?##??#..? 1,1,2,1,6,1
??#???#?#?#?? 4,6
?#.???#?##????#?? 1,10
??.??#.?#?? 3,3
#???#?..???.??.? 1,3,3,1
.?#?????.??? 6,1
???.?????#? 1,2,2
??.?#?#??.?? 1,1,3,2
?#??.???#.?????. 4,1,2,1,1
????????.#??#.??#.? 1,1,1,4,3,1
??????##?#????##?. 3,5,3
??#????#???????## 4,1,1,1,3
####?.???##???#.?. 4,6,1,1
??????#?????#???#? 3,2,2,2
????#.?####????? 3,9
.????????#???# 1,8
?????.??..?? 3,1,1
####???#???.???#??? 4,6,1,4
#??#???#???#?????? 5,1,1,1,2
?#?#???..?? 5,2
.#?#???.?.? 5,1
???#???#?#? 3,3
?#..???##????? 2,1,2,1
???.??#????# 1,3,1,1
??????????? 1,1,6
???.??.?###? 3,4
?.??#.??#?##??? 1,5
??.????????#???? 1,4,3
???#???#???????.??? 9,1,1
.??##??.?#?? 4,1,1
????#?????????? 1,2,6,1
?????.???????#?????? 5,1,11
.??????????#??? 2,1,2,4
??????????..???????? 10,2,1,1
?#.???????#????.?? 2,7,1,1
???#?.???.???#?#?#? 1,1,2,1,5
??##???????#?##? 3,2,5
?????#???.?#.?? 6,1
..???#?#???#. 1,1,2,1
???#?##.?#??###?#? 1,4,10
????..??#?## 2,1,6
?#???????. 3,1,1
?#?????##?#?#?????? 3,13
???#????##?? 4,4
?????.????.?#??#?. 5,3,5
.????#?????##?? 2,3,5
.?.?.##??? 1,4
.???.#?.?#??? 3,1,3
??.#??#??#???#??. 9,3
???.???????#?#?# 1,2,3,1
?#?#???#??.#?..?#?? 6,1,1,3
????.?#??#???. 1,1,6,1
..??????#?? 1,4
##.?.??#.? 2,1,1
??##?##?.????##?. 1,5,1,4
??#???????. 2,2,2
??????.??? 1,1,1
??#??????.?#?.# 1,6,1,1
?.?.????????????? 1,1,1,8
????.????# 2,2,1
??#?#####??.??? 2,5,1,2
#..???##?#? 1,1,6
#????.?#???#???# 2,1,7,2
.#?????#?#??.# 1,4,3,1
??#??????#.#???# 2,1,1,2,5
?.???#???? 1,2,1
????.?.?????????? 3,1,2
?#??????#?????.? 4,6,1
?.#?#??.#????.?? 1,3,3,2
#?????.?#?##?.#.?..? 6,5,1,1,1
???.?#.??.???...? 1,1
.??????..????.? 1,2
#???????#?#??.?????? 1,1,2,3,1,6
??.?????????? 1,1,5
#??#?.#?#. 5,1,1
.#??.?????. 2,4
.?#???###???? 1,5
?..?????#? 4,2
?.#??????#????###?.? 1,1,9
.?#??????. 1,1,1
?##.?????. 2,2,1
?#????.??#????. 3,1,3,2
???#??#?##?? 1,1,5,1
.????#.?##? 4,3
?.?#?.##?#??????#?#. 1,3,13
??????##??#?? 4,3,1
???.#?#.?..?#??##?. 3,2,2
?????????.? 1,6
????#?#?.????.?.??# 1,1,2,1,1,3
???#?#??#.??.????.?? 7,1,2,1
??##?.??#???#? 1,2,3,2
??????#?#?###??##?? 11,3
#??????##..??????. 1,7,5
??.??...??????#??#. 1,10
??#????#??#.?#??#??? 1,1,1,1,7
??.?#??#???#???.#? 1,1,8,1
#??..?#?.#??.#?#?? 2,2,2,4
?##????????#??????# 7,6,1,1
???.?.#??#?????#?.? 1,1,1,3,2,1
#...??.????#????. 1,2,6
????#.?????#. 3,1,1,1
?.??#..???????? 1,3,1,2,1
?????.?.#.???.#..? 5,1,1,2,1,1
?#.?#?.###??????. 1,1,7,1
?.?#????###?#.?# 1,2,5,1
.?????.????.??. 3,3,1
????#?????????????# 7,1,2,1,1,1
?#????##?????. 2,6
?#??##?#?#.???#?# 10,3
#?#?#?????????.??#?? 8,2,1,4
?#??####??.?##. 8,2
???.??????? 2,5
????##?##???#????. 1,12,1
??????.#?#?#??? 5,7
??#?#????#?##??.?? 8,1,2,1,1
#?????.??#?## 1,2,4
?????..??????#????? 4,8,1
?.??#?#??????#.????? 4,3,1,2
.???.#????. 1,2
???##?###??...? 9,1
.#????.???#?. 2,5
...#??#????? 1,1,4
.?#?#??.#???#?##??? 2,2,1,9
.????#??#???##.. 2,9
...#???#.?????. 1,3,3
.###?#?.?????#. 5,1,2
?????#.??#?#?.#?#.? 1,2,4,1,1
#?..?#???#?#? 2,7
??????###?#???. 1,7,2,1
?#??.?????? 3,1,1
??.#??..?##?#? 2,3,6
?????.??????#?.??## 2,1,1,2,2,4
??##?#??#????#..? 8,2
???.#.????? 3,1,3
?.#??.#.?? 1,1,1
??###??#??.###?.? 10,3,1
.?.?#??.?.#???????? 1,4,2,5
#??.???.?#?#????.? 1,1,2,5,1,1
######??.???. 6,1
??.?#?????#?#?. 2,11
?.?.?...????.?#.? 1,3,1
??.##??.???.?????? 1,2,1,5
??.??..?#?#???..#?. 1,1,7,2
?????.??#??????##?? 2,11
#??#?#??..??..?.. 8,1,1
#?#???#?#??#????#?.? 1,15,1
?.?##???#.?#. 7,1
???..?.?#?? 2,2
???#?#??.?? 6,1
?..???????? 1,1,2
?.?????????? 4,1
?#?.?.?#?????#?# 2,1,1,3,1
??#??#?.???##. 4,4
.??.???#..?? 1,4
?.???#?#?? 1,1,4
.??????.??????#?#.. 6,1,1,5
#?#????##?#?.##? 4,3,1,3
.?#??????????? 1,1,8
???????????#? 6,1
???.#?.#?#???#????# 3,1,1,1,8
?#????#?.?#???. 2,2,3
??#.?????.??#??#?? 3,1,3,1,1,1
?.?#??##??? 2,5
.?#???#??#??? 1,7
.?.?????..???. 5,1
??????.??? 1,1,1
.??#???#?.??#??# 1,1,2,1,1
???#??##?#?# 1,1,7
?.#??.?..#.??#?.#? 1,3,1,1,1,1
???#?###?..?.??????? 9,1,3,1
..????#????# 1,7
##??????#??#?? 3,2,4,1
?#?.????#?? 2,2,1
?##??#?#???????..#?? 6,1,1,3,1,1
?.??#?#??..?????. 5,2
????.?##.? 1,1,2
???.?#?????????#??? 2,3,8
##??#.?#?#?? 2,1,1,1
?#.?#??.?? 1,2
???#?#??...##?#??? 5,5
#??##??#????..#??? 5,2,2,3
#??#?????? 4,2,1
????.?.???#? 3,1,4
??????#??? 4,3
????#??????#????#??? 10,2
????#???????#? 1,2,8
?.????#???#.#??.? 1,6,1,1
?.???????????#?#? 2,8
???????.??? 1,1,1
??????#??????.? 1,1,3,1,1
????###??.?.???#? 7,1,2
???.????#???? 2,1,5
.?#??#???#? 1,2,2
###?.???##?? 4,6
????#??.????????. 3,1,1,2,1
??#????#????##?.??? 10,3,1,1
???????.???##???#?# 4,1,9
##?#???#??.?????.??# 4,4,2,1,2
??????????##????#??. 1,12
?##?????###????.?? 12,1,1
???#??..?#?#??.? 2,5,1
??#.?.##???.##??#?.# 1,1,5,5,1
#??????????.#???#? 1,5,1,5
?.??#..?#??. 1,2
.?.??#??###????????? 1,11,1
???.?????#??????##? 1,3,3,1,4
???#??.??.????#? 4,1,1,1,3
?.????.?#??.?#??#?? 1,3,4,2,3
?.?????.???##??#??? 1,1,1,1,7
?##??#???????? 5,1,2
#?????.#????#???##.? 3,1,1,9,1
#?.?.#???#???. 1,1,1,3
????#????##.? 5,2
##??.????##?. 4,1,3
???????.#? 5,1,1
#???#????#??. 1,3,3
???.?.?#?????#?# 3,1,2,4
?#??#??##?. 2,5
???#?##??.??.#?.??? 5,1,1,2
??????#??##????..#? 1,10,2,1
?.?.?.#?###??.?##? 1,1,5,1,2
???????#???. 1,7
#???..??????? 3,1,4
??#?#..?#????.?# 5,1,1,2
?????????#???#.?? 3,2,2,3,1
?#?.??##????#?##? 2,1,11
???#?????# 1,5,1
??##??..#?????# 5,7
??#?????.???##.#?#? 6,1,2,3
????#????. 1,2,1
..??##?#?#??#?.?.?. 12,1
??##?##?.??.. 6,1
?##.??#?#??#?? 3,7
.?.??#??#???#? 1,7,1
??#?##?.#?#??.???? 6,5,1
???#??????#?.???.? 1,6,2,1,1,1
?????????###??# 1,10
?.#???????.? 6,1
.??#.?.?????#??. 1,1,2,3
???.#???.? 1,1,1
????#?????##.#? 1,2,2,2,2
??.#?.?????????.?. 1,1,6,1,1
????#????##???????.. 11,3,1
.?#.????#?. 2,1,2
#?#?.?????#? 4,1,3
??????#???????? 2,2,1,1,3
.????.???#?#?.???##? 4,5,2
?.##??##????##??.?? 12,1
??????#?.?#??. 6,2
??#?.?..#.??##??? 2,1,1,5
.#???#..??#????#??? 1,3,2,4
??#?????#?#?.?????.? 9,4,1
?##?.?##??##?##.?? 2,10
.?.??#???????#?#..? 1,2,1,5,1
??????#.?.??#??#.# 3,1,1,4,1
#?????#??#????##. 12,3
???.???.#????##? 2,3,3,3
#?####?#?#.??????# 10,1,2,1
??.???#??.????.??.? 1,1,4,1,1,1
????????.#? 4,2
..????#.????.?.?#? 2,1,3
?????#???.???? 1,1,3,1
??.#..?#???# 1,1,2,1
?##?????##? 2,1,3
?#?..??.??? 1,2,1
.????#???##.?? 1,6
?#??????#????# 3,3,1,1
.???.???????##?# 2,5,5
??.??????.?????? 1,4,3
#??#???#????.??##. 1,7,1,2
???.??#???##??. 2,1,1,3,1
?#?##???.#?##? 5,1,5
??.?#?.???.???????.? 1,3,1,6,1
?#.#????.??#??#??#?? 2,1,2,4,6
..????..???#???#???? 1,6
#??#???????.???#?#? 1,5,1,1,6
???##?????..#??????? 7,8
?##?????..?????? 5,1,1,1
#??????.?#?. 2,3,2
???.???????????.??. 1,1,1,7,1,1
.??#????##??#.#???? 1,2,6,2
?.##?#??????#??#?? 7,4
?#.##????##?? 1,3,4
..???.????. 2,3
?#?????#?#.? 2,1,3
???..??.?? 1,1,1
??????????#?#???#??# 3,12,1
#??##?#????.. 1,6,2
???.????#???? 1,1,3,1
#?????##?#?##??# 1,1,10
?..##????? 1,2,1
?..?.????#? 1,2
.???.?.????.??#??? 2,1,4
???????#?. 3,3
??????.#???.???? 1,1,2,1,1
.?????.?#?#?. 4,1,2
????###?##?.?#?.? 1,8,3
??#???????#.????. 5,1,1,1
.#?..??.???#.??#? 2,1,3,3
?#??#..????..?.????? 5,1,1,1,1,2
?#?#?#?????.# 1,4,1,1
.?##?#?#..???????? 2,3,6
????#?????#?#. 1,4,3
???#??#??#??#?? 8,1,3
?##?#?#????#?#?#??.? 2,10,3,1
??.?.??#????#?#??. 1,1,2,4,3
?#???#??#???.#??? 2,1,5,1,1
???#??.??###.?#? 3,5,2
?????.??#??. 2,1,3
#?.??#????????? 2,5,1,1
???.???#?####??#?? 2,1,9
#..#.??????#?#??.??? 1,1,10,3
?###??#??????#?#?.? 8,4,2,1
?????#???..????##?#? 6,5
#??#??.?#?##?????? 2,1,1,2,5,1
??????.??? 1,3,1
?#..#..?????..?.? 2,1,5,1,1
.#??#???###??????.#. 14,1
?.?#???#?????????#? 1,1,3,1,1,6
???##????#???#??#?# 5,1,1,6,1
?#????.?????##??.? 4,2
????.???###??#?????? 1,1,15
#??#???#.???? 8,2
##?#???#?.?? 5,2,2
.?#??##.?. 2,2
?#??##???? 5,2
??#?????#?##??????? 12,2
??????#?#..????? 1,6,4
.?#??#??????? 2,1,1,1
????#?#??#???#????? 1,3,9,1
??????#?????.#?# 10,1,1
??#?.??##?###?? 3,8
??#.??##?##??#? 2,1,8
??#??#??.???? 1,3,1,1
#?..?#??##??????.?? 1,6,1,1,1
?#?????##????#?? 5,4,4
??#????#.?? 2,2,1
??#?.???##..##?? 1,2,5,2,1
???#?.????????#. 1,6,1
????##?#?##?#.??.? 2,2,4,1,2,1
???#?.??#?#??#. 1,1,3,1,1
.?#.?#???.#? 1,1,2
?#.??####?#????? 1,11
??????.??.##?#??? 4,1,6
?.??#??.???. 5,1
??.#?##.?????##?# 1,1,2,2,6
????.????#?#? 4,6
#??????##?????.#?. 12,1
.#?????#?.#????##??? 8,4,3
????#??#?##??. 11,1
??..#??#??##??#?. 1,1,1,4,1
?#????????.#???.? 4,3,3
??.#????.?#??????. 1,4,1,1,2
??????#??#?##???. 6,5
.????????#?#? 4,4
.##..?????# 2,5
??????????.? 1,5,1,1
?????#?????.?.?? 1,4,2,1,2
.????#?.??#?#???? 2,2,8
#?????#?##.???? 1,1,6,1,1
?????????? 1,4,1
.#?.#?????????? 1,3,6
#.?.????#?? 1,5
??.##?????.?#?#??#? 1,3,3,1,2,2
#?#?..#?#????? 4,3,1
????.?.?#????????#? 3,11
##????????.. 2,2,1
???#??###.?##???#?? 6,6
??...?????? 1,4
?#.?.?.??? 2,1,1
??#?.???.?.?#.??.?? 2,3,1,1,1,1
.??..??????#???????? 2,6
?????.???.#?..?# 4,1,1,2
?#??#????? 5,2
??????.????##?.????? 4,1,2,3
??#?#?#?.#???? 3,1,2,1
.?##.?#.?.??# 3,1,1,3
??#?????#?#.??? 9,2
.????#???#? 1,3,1
..??.????..?#?? 1,2,1
??#?.????# 1,1,5
?.????.???##?#? 1,1,2,5,1
?????####?#?#??.??.? 12,1
#.?.?????????.#???? 1,1,3,1,1,2
.?#??##?????.#?? 10,1
????????#??????..??? 1,1,6,1,1,1
??#??#???#?.?.?#. 8,2
????..??????.??. 3,4,1
??.???##???.?..???? 6,2
????##..??? 1,2,3
.#?..???????. 1,1
?????#????#??????? 1,1,1,1,6,1
?.????#???? 3,2,2
?????????.??. 3,1,1,1
.?????.??? 3,1
???.?????????? 1,1,6
#???#?#.####?#??#?#? 1,4,11
..??#??#?...?.??.?? 6,2
?#???..?#?#????? 2,1,4,1,1
????????####???? 2,9
??.#?..#????#?..???? 1,2,1,2,2,2
??.#?.???? 1,1,2
?????#?.?.#?? 4,1,2
?????????.?# 1,1,1,1
?????#####??? 1,8,1
.????#?#??#.???? 8,1,1
???##??#.???? 4,1,3
.??????#??? 1,5
.??#?.??..#?? 2,3
??##?#?????#???? 6,1,1,1,1
??#?##.#??#?.?. 5,4,1
#??##????.??#?? 5,1,1,1,1
?##???###.# 4,3,1
???#?????????#?.? 4,2,5
#.?.?.?#??.?? 1,2
.?#.?..????? 2,2,1
?.#?????????? 1,1,3,2
???????.??? 2,1
?##?????????????.. 2,4,4
???#?#?....????.?.. 3,1
##?#???.??? 4,1,1
.???#????.#?????# 4,2,2
.?##?.?#???#??????? 3,4,1,1,1,1
???.#?#?????#?. 1,5,1
??????????##??###.. 6,4,3
??.?#???????.#? 3,1,1,2
#??#?#????#?#???#.? 2,6,1,2,1,1
#?#???????#???#.???? 1,5,1,2,1,1
?#????#????##??#? 2,1,7,3
?.#??.?###?.#? 2,5,1
??##???????????#?# 1,3,1,2,1,1
????????.??# 4,2
????.??#??? 3,2,1
??#?#?..??#?# 1,4,3
#????#??.##.????## 1,1,3,2,6
??..?#???.??#?. 1,1,1,1,2
???.??#?????? 4,1
???#???..? 1,2,2
???.????????????? 2,7,2,1
??#.?????? 1,1,3
??#?????#?##????#? 1,1,2,1,8
??.#?.?#?.?. 1,2
.?##???##????? 3,4,1,1
??#??###?.?? 2,4,1
?#?.????#?????#? 2,5,6
#?.?????#?#?#???#?#. 1,3,12
??.??.##?.? 1,1,2
??#??#?#?#.?? 3,3,1,2
.?##??.?????.? 4,2
??????#?#????#.. 1,8,1
??#?.?.???.#????. 2,3,4
.?#?.??#??? 1,4,1
?.???#???.?#. 1,6,1
?.?.?????#.##?##?. 1,1,3,6
?.???#?#?#??????#??. 11,4
?????????????.#?#??? 1,5,1,1,4,1
??#..????##?#???.?? 1,1,4,4,1
??.???????. 2,5
?.?###??..??.?##???? 6,1,5
???#?????? 2,1
?..?..??????.?##???? 1,3,2,1
???#????#?.???#??#. 6,3,2,4
?#?##???#???#?.#??. 13,3
?#???.?????? 5,1,1
????#???###?.#?? 1,5,3,1,1
???#??##??????##???# 1,2,3,1,1,6
..?###???????.??## 8,1,2
#?.??..??? 1,1,1
.?#?.??.?#? 2,1,3
??????.#?????..???. 2,2,2,1,1,1
.?.???####??# 5,1
##.?..??.?. 2,2
???#??#??..#?????? 4,1,1,1,2,1
?#?.??#?#?? 1,5
?#?#???##?#?..?#?.. 12,1
??#????##???.??.???? 11,1,1
?#???????#??????##?? 3,5,6
???????????.?? 2,2,4,1
???????.??? 2,1,2
?.#?#??.?? 3,1
??#.??#??.???#????. 2,1,3,1,3,1
#.#??????..? 1,4,1
?#?##???#????#???? 1,3,1,1,4
??????#?#?#??????? 9,2
.??#.#???#?#. 1,1,1,4
#????##??#?.??????#? 11,7
?##.??#?##. 2,6
????.?..??? 2,1,1
??.????.????. 3,1
???????.?# 4,1,2
?#.?#???.????.?? 1,3,1,1,1
??#??##?.? 1,4
.?##????????.?.??? 10,2
???#?????.? 4,1
???????#?.??##? 1,1,1,3
.???#?.?????? 2,5
??#?????##?##???? 5,4,5
???.?#????#???#?#? 2,1,2,1,5
?.?????.??#??? 5,5
.??????###?.??##? 4,3,4
.???..???.?##?????#. 2,2,6,2
???##????###? 1,3,5
#??#?#??#?#.??.? 2,8,1
??#?.?..##???#?? 1,1,4,3
?????.???? 1,1,1
.??????##??? 1,2,4
????####??#?.? 1,7
???##???????????.??? 2,1,8,1
?#?.?#??.??????#?. 2,1,7
.#?#??#???? 7,1
???..?.?#?#?###?? 1,1,9
.####??##???????.?# 4,3,5,1
??#..???#???#..? 1,8,1
??#.??.??##????#. 2,1,7
???#???..#??. 3,1,1
??##?###?#?#?#???? 14,1
?#?.??#??? 1,3,1
?.#?????#???.?#???. 8,5
?###??#???#????? 7,1,1,1
..?????????.??.?? 3,5,1
????#?????? 2,4,1
??#?#?????????? 6,1,1,1
?.?#??.###?#?????# 1,3,3,2,1,1
#??#..??#? 2,1,4
...?#??#??? 1,5
.??#?##??????. 5,2
?#.????#?.?.?? 1,4,1,2
#??#???#??#???????# 2,1,3,3,2,1
??#??#.??? 3,1,1
??#??..??#?.??## 2,1,4,3
????????#???? 6,2
??##??..?#?#??# 4,1,7
?..#????????? 1,3,2
??#?????????.???? 4,1,1,2,1
?.???????? 1,1,1
##??#?????? 2,2,3
???#????#??. 3,1,1,1
???#??.??? 2,2
?.???#??????? 1,2,1,2
#?#..?#.???#?? 3,1,3
.??####?#???# 4,5
?#???.???#?? 1,1,1,2
###??#?.##??? 3,3,2,1
?.?????.?????.??.? 1,1,1,1,3,2
???#????#?###?#? 4,1,8
?##?.####??#?. 4,8
??.?##??.?????###? 1,4,8
??.?????#??#??????? 2,1,3,1,5
?#.????..???????##?? 2,1,1,4,3
?#??#.???#??###??#? 2,1,1,1,3,3
..?##?????#????? 4,5
???##?.?###?.? 2,4
????.??..?? 2,1,1
?#????#??#.?????? 2,6,1,1,1
??#?..??.?#?#? 1,1,1,3
????#?#????#?????#?? 14,3
???.#?.??????.??.# 3,1,1,1,1,1
..#.#?#???#??# 1,10
?#??..????????# 2,1,3,1,1
?#..??#??? 2,3
?.###???#.. 3,2
.#??#??##???#? 1,10
????????##?.?###? 8,4
.???###..?..?# 4,1,2
??#?#??.??.#??? 6,4
??##????#??### 3,1,4
#?..##?.?????###???? 2,2,8,1
#????????##..??## 3,1,4,4
????#??#???.? 1,7
?#??###?#??.? 1,6,1
???#??.?#??##?#?. 3,9
.?????????#.????.#? 2,5,1,1,2
?.?????#?????#?? 1,2,1,3
?##???###?#??. 11,1
????#????? 1,2,1
.??.?.??#?#??? 1,7
?..??...?????????.? 1,6
?#?...#??? 2,3
.?#..#?#..? 1,3
?.??????..??#??? 3,5
?.??..???????##??#? 1,1,13
##??#.???????.?##??# 5,5,1,2,1
???#??#?#.???#???.?? 8,2,1,1,1
?????..?####?#?? 3,8
??#??.?#??..??.# 1,1,3,1,1
?????#??##??#?#??#?# 8,8
???.?##?..? 2,3
.??.??#?#??#??.#? 1,1,8,1
###????###???? 3,7
???##..#?. 2,2
..?????#??.?.? 3,3,1,1
#.??.?.#??###??#?#?? 1,1,1,9,1,1
?.?.#.??????##???# 1,1,2,1,6
.??#??#??????? 1,4,1,1
?#?.??#?.?#?#???? 1,4,2,1,3
???.??????#? 1,5
?????..?.???? 3,1,1,1
.????####?.?????. 6,3
???#??#??.?#???? 6,5
#..??####??? 1,4
?#??#?#?##?????.#? 11,1,1
??#?#..?#??# 3,4
??#.???..??#??????#? 3,1,1,1,1,3
?#??.????#????? 4,1,1,4
.#?#?#?#?#??.#????#? 11,1,1
#?#??.???.. 4,2
??#??##?.. 2,3
????.?.##???? 1,1,1,6
.?????.????????.?#? 1,1,6,1,1
??#??.?#?##??? 3,1,6
?.???#???##?##.? 1,1,7
?????.#????#?#?? 2,2,9
#???#?????.#??? 3,1,1,4
???#.#?.??.#??? 3,1,1,2,1
???#????????????? 9,4
?.#.??.??? 1,1,2
.?#??.??#.? 3,1,1
??????.#??.. 2,2
?##???##??#? 4,5
????###?##??#? 1,10