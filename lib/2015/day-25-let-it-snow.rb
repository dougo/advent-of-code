class WeatherMachine
  def self.parse(console_message)
    console_message =~ /row (\d+), column (\d+)/
    new($1.to_i, $2.to_i)
  end

  def initialize(row, col)
    @row, @col = row, col
  end

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

  def code
    code_at(@row, @col)
  end
end

if defined? DATA
  machine = WeatherMachine.parse(DATA.read)
  puts machine.code
end

__END__
To continue, please consult the code grid in the manual.  Enter the code at row 3010, column 3019.
