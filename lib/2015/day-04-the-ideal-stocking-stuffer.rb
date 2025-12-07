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
