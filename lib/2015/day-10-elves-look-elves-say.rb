class Elves
  def initialize(seq)
    @seq = seq
  end

  def look_and_say(n = 1)
    n.times { say(look) }
    @seq
  end

  private

  def look
    @seq.chars.chunk { |digit| digit }
  end

  def say(chunks)
    @seq = chunks.map { |digit, chunk| "#{chunk.length}#{digit}" }.join
  end
end

if defined? DATA
  elves = Elves.new(DATA.read.chomp)
  puts elves.look_and_say(40).length
  puts elves.look_and_say(10).length
end

__END__
1321131112
