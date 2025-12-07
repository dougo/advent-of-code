class SecurityElf
  def next_password(password)
    begin
      password = password.succ
      # If the password contains a confusing letter, just replace the first one immediately rather than continue
      # looping through all the successors. E.g. foobar -> fpaaaa rather than trying foobas, foobat, ...
      if i = password.index(/[iol]/)
        l = password.length
        password[i..-1] = password[i].succ
        password = password.ljust(l, 'a')
      end
    end until legal_password?(password)
    password
  end

  def legal_password?(password)
    has_straight?(password) && has_no_confusing?(password) && has_two_pairs?(password)
  end

  def has_straight?(password)
    trigrams = (0..password.length-2).map {|i| password[i..i+2] }
    trigrams.any? { |t| t[0].succ == t[1] && t[1].succ == t[2] }
  end

  def has_no_confusing?(password)
    !(password =~ /[iol]/)
  end

  def has_two_pairs?(password)
    password.scan(/(.)\1/).to_set.length > 1
  end
end

if defined? DATA
  elf = SecurityElf.new
  old_password = DATA.read.chomp
  new_password = elf.next_password(old_password)
  puts new_password
  puts elf.next_password(new_password)
end

__END__
cqjxjnds
