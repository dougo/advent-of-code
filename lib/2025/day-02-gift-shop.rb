class GiftShop
  attr :id_ranges

  def initialize(text)
    @id_ranges = text.split(',').map { new_id_range(_1) }
  end

  def new_id_range(text)
    Range.new(*text.split('-').map(&:to_i))
  end

  def invalid_id?(id, repeated_more_than_twice: false)
    id = id.to_s

    if repeated_more_than_twice
      (1..id.length/2).each do |i|
        prefix = id[0...i]
        return true if id =~ /\A(#{prefix})+\z/
      end
      return false
    end

    id.length.even? && id[0...id.length/2] == id[id.length/2..]
  end

  def invalid_ids(repeated_more_than_twice: false)
    invalid = []
    id_ranges.each do |id_range|
      id_range.each do |id|
        invalid << id if invalid_id?(id, repeated_more_than_twice:)
      end
    end
    invalid
  end

  def sum_of_invalid_ids(repeated_more_than_twice: false)
    invalid_ids(repeated_more_than_twice:).sum
  end
end


if defined? DATA
  input = DATA.read
  shop = GiftShop.new(input)
  puts shop.sum_of_invalid_ids
  puts shop.sum_of_invalid_ids(repeated_more_than_twice: true)
end

__END__
4487-9581,755745207-755766099,954895848-955063124,4358832-4497315,15-47,1-12,9198808-9258771,657981-762275,6256098346-6256303872,142-282,13092529-13179528,96201296-96341879,19767340-19916378,2809036-2830862,335850-499986,172437-315144,764434-793133,910543-1082670,2142179-2279203,6649545-6713098,6464587849-6464677024,858399-904491,1328-4021,72798-159206,89777719-90005812,91891792-91938279,314-963,48-130,527903-594370,24240-60212
