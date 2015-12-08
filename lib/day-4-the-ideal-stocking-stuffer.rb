=begin

--- Day 4: The Ideal Stocking Stuffer ---

Santa needs help mining some AdventCoins (very similar to bitcoins) to use as gifts for all the economically
forward-thinking little girls and boys.

To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least five zeroes. The input to the
MD5 hash is some secret key (your puzzle input, given below) followed by a number in decimal. To mine AdventCoins,
you must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...) that produces such a hash.

For example:

 - If your secret key is abcdef, the answer is 609043, because the MD5 hash of abcdef609043 starts with five zeroes
   (000001dbbfa...), and it is the lowest such number to do so.
 - If your secret key is pqrstuv, the lowest number it combines with to make an MD5 hash starting with five zeroes
   is 1048970; that is, the MD5 hash of pqrstuv1048970 looks like 000006136ef....

--- Part Two ---

Now find one that starts with six zeroes.

=end

require 'digest'

class AdventCoin
  def mine(secret_key, num_zeroes = 5)
    prefix = '0' * num_zeroes
    i = 1
    while true
      hash = Digest::MD5.hexdigest(secret_key + i.to_s)
      return i if hash.start_with? prefix
      i += 1
    end
  end
end

if defined? DATA
  input = DATA.read.chomp
  puts AdventCoin.new.mine(input)
  puts AdventCoin.new.mine(input, 6)
end

__END__
ckczppom
