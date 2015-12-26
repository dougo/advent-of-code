def code_at(row, col)
  code = 20151125
  r, c = 1, 1
  until r == row && c == col
    code = next_code(code)
    if r == 1
      r = c + 1
      c = 1
    else
      r -= 1
      c += 1
    end
  end
  code
end

def next_code(code)
  (code * 252533) % 33554393
end

if defined? DATA
  code = 20151125
  (1..6).each do |r|
    (1..6).each do |c|
      print "#{code_at(r,c)}  "
    end
    puts
  end
  puts

  input = DATA.read
  input =~ /row (\d+), column (\d+)/
  row, col = $1.to_i, $2.to_i
  puts code_at(row, col)
end

__END__
To continue, please consult the code grid in the manual.  Enter the code at row 3010, column 3019.
