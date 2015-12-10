=begin

--- Day 10: Elves Look, Elves Say ---

Today, the Elves are playing a game called look-and-say. They take turns making sequences by reading aloud the
previous sequence and using that reading as the next sequence. For example, 211 is read as "one two, two ones",
which becomes 1221 (1 2, 2 1s).

Look-and-say sequences are generated iteratively, using the previous value as input for the next step. For each
step, take the previous value, and replace each run of digits (like 111) with the number of digits (3) followed by
the digit itself (1).

For example:

 - 1 becomes 11 (1 copy of digit 1).
 - 11 becomes 21 (2 copies of digit 1).
 - 21 becomes 1211 (one 2 followed by one 1).
 - 1211 becomes 111221 (one 1, one 2, and two 1s).
 - 111221 becomes 312211 (three 1s, two 2s, and one 1).

Starting with the digits in your puzzle input, apply this process 40 times. What is the length of the result?

Neat, right? You might also enjoy hearing John Conway talking about this sequence (that's Conway of Conway's Game
of Life fame).

Now, starting again with the digits in your puzzle input, apply this process 50 times. What is the length of the
new result?

=end

class Elves
  def look_and_say(seq)
    last = nil
    i = 0
    new_seq = ''
    seq.to_s.chars.each do |digit|
      if digit == last
        i += 1
      else
        new_seq << say(i, last) if last
        i = 1
      end
      last = digit
    end
    new_seq << say(i, last)
    new_seq.to_i
  end

  private

  def say(i, digit)
    "#{i}#{digit}"
  end
end

if defined? DATA
  elves = Elves.new
  seq = DATA.read.to_i
  40.times.each { seq = elves.look_and_say(seq) }
  puts seq.to_s.length
  10.times.each { seq = elves.look_and_say(seq) }
  puts seq.to_s.length
end

__END__
1321131112
