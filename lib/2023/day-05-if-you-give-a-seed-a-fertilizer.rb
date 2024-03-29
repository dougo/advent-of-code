=begin

--- Day 5: If You Give A Seed A Fertilizer ---

The almanac (your puzzle input) lists all of the seeds that need to be planted. It also lists what type of soil to
use with each kind of seed, what type of fertilizer to use with each kind of soil, what type of water to use with
each kind of fertilizer, and so on. Every type of seed, soil, fertilizer and so on is identified with a number, but
numbers are reused by each category - that is, soil 123 and fertilizer 123 aren't necessarily related to each
other.

For example:

seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4

The almanac starts by listing which seeds need to be planted: seeds 79, 14, 55, and 13.

The rest of the almanac contains a list of maps which describe how to convert numbers from a source category into
numbers in a destination category. That is, the section that starts with seed-to-soil map: describes how to convert
a seed number (the source) to a soil number (the destination). This lets the gardener and his team know which soil
to use with which seeds, which water to use with which fertilizer, and so on.

Rather than list every source number and its corresponding destination number one by one, the maps describe entire
ranges of numbers that can be converted. Each line within a map contains three numbers: the destination range
start, the source range start, and the range length.

Consider again the example seed-to-soil map:

50 98 2
52 50 48

The first line has a destination range start of 50, a source range start of 98, and a range length of 2. This line
means that the source range starts at 98 and contains two values: 98 and 99. The destination range is the same
length, but it starts at 50, so its two values are 50 and 51. With this information, you know that seed number 98
corresponds to soil number 50 and that seed number 99 corresponds to soil number 51.

The second line means that the source range starts at 50 and contains 48 values: 50, 51, ..., 96, 97. This
corresponds to a destination range starting at 52 and also containing 48 values: 52, 53, ..., 98, 99. So, seed
number 53 corresponds to soil number 55.

Any source numbers that aren't mapped correspond to the same destination number. So, seed number 10 corresponds to soil number 10.

So, the entire list of seed numbers and their corresponding soil numbers looks like this:

seed  soil
0     0
1     1
...   ...
48    48
49    49
50    52
51    53
...   ...
96    98
97    99
98    50
99    51

With this map, you can look up the soil number required for each initial seed number:

Seed number 79 corresponds to soil number 81.
Seed number 14 corresponds to soil number 14.
Seed number 55 corresponds to soil number 57.
Seed number 13 corresponds to soil number 13.

The gardener and his team want to get started as soon as possible, so they'd like to know the closest location that
needs a seed. Using these maps, find the lowest location number that corresponds to any of the initial seeds. To do
this, you'll need to convert each seed number through other categories until you can find its corresponding
location number. In this example, the corresponding types are:

Seed 79, soil 81, fertilizer 81, water 81, light 74, temperature 78, humidity 78, location 82.
Seed 14, soil 14, fertilizer 53, water 49, light 42, temperature 42, humidity 43, location 43.
Seed 55, soil 57, fertilizer 57, water 53, light 46, temperature 82, humidity 82, location 86.
Seed 13, soil 13, fertilizer 52, water 41, light 34, temperature 34, humidity 35, location 35.

So, the lowest location number in this example is 35.

What is the lowest location number that corresponds to any of the initial seed numbers?

--- Part Two ---

Everyone will starve if you only plant such a small number of seeds. Re-reading the almanac, it looks like the
seeds: line actually describes ranges of seed numbers.

The values on the initial seeds: line come in pairs. Within each pair, the first value is the start of the range
and the second value is the length of the range. So, in the first line of the example above:

seeds: 79 14 55 13

This line describes two ranges of seed numbers to be planted in the garden. The first range starts with seed number
79 and contains 14 values: 79, 80, ..., 91, 92. The second range starts with seed number 55 and contains 13 values:
55, 56, ..., 66, 67.

Now, rather than considering four seed numbers, you need to consider a total of 27 seed numbers.

In the above example, the lowest location number can be obtained from seed number 82, which corresponds to soil 84,
fertilizer 84, water 84, light 77, temperature 45, humidity 46, and location 46. So, the lowest location number is
46.

Consider all of the initial seed numbers listed in the ranges on the first line of the almanac. What is the lowest
location number that corresponds to any of the initial seed numbers?

=end

class Range
  def &(range)
    [self.begin, range.begin].max .. [self.end_int, range.end_int].min
  end

  def increment(delta)
    (self.begin + delta) .. (self.end_int + delta)
  end

  def end_int
    if !self.end
      Float::INFINITY
    elsif exclude_end?
      self.end - 1
    else
      self.end
    end
  end

end

class Almanac
  def initialize(text)
    seeds_line, *map_texts = text.split("\n\n")
    @seeds = seeds_line.split(': ')[1].split(' ').map(&:to_i)
    @maps = map_texts.map { Map.new(_1) }
  end

  def seed_ranges
    @seeds.each_slice(2).map { |start, length| start ... start + length }
  end

  attr :maps

  Conversion = Data.define(:range, :delta)

  class Map
    def initialize(text)
      map_line, *map_desc = text.lines(chomp: true)
      @source_category, _, @destination_category = map_line.split(' ')[0].split('-')
      @conversions = map_desc.map do |ranges|
        dest, source, length = ranges.split(' ').map(&:to_i)
        Conversion[source ... source + length, dest - source]
      end

      # Find gaps in the source ranges and fill them with delta-0 conversions.
      ranges = @conversions.map(&:range).sort_by(&:begin)
      gaps = []
      gaps << (0 ... ranges.first.begin) unless ranges.first.begin == 0
      ranges.each_cons(2) do
        gaps << (_1.end ... _2.begin) unless _1.end == _2.begin
      end
      gaps << (ranges.last.end ..)
      @conversions += gaps.map { Conversion[_1, 0] }
    end

    def convert(number)
      number + @conversions.find { _1.range.include? number }.delta
    end

    def convert_range(range)
      @conversions.filter_map do |conversion|
        subrange = (range & conversion.range)
        subrange.increment(conversion.delta) if subrange.size > 0
      end
    end
  end

  def seed_conversions(seed)
    @maps.reduce([seed]) do |hist, map|
      hist + [map.convert(hist.last)]
    end
  end

  def seed_conversion(seed)
    seed_conversions(seed).last
  end

  def seed_locations
    @seeds.map { seed_conversion(_1) }
  end

  def lowest_seed_location
    seed_locations.min
  end

  def lowest_seed_location_in_ranges
    @maps.reduce(seed_ranges) do |ranges, map|
      ranges.flat_map { map.convert_range(_1) }
    end.map(&:begin).min
  end
end

if defined? DATA
  almanac = Almanac.new(DATA.read)
  puts almanac.lowest_seed_location
  puts almanac.lowest_seed_location_in_ranges
end


__END__
seeds: 1848591090 462385043 2611025720 154883670 1508373603 11536371 3692308424 16905163 1203540561 280364121 3755585679 337861951 93589727 738327409 3421539474 257441906 3119409201 243224070 50985980 7961058

seed-to-soil map:
3305253869 1699909104 39566623
3344820492 1130725752 384459310
3244681427 1739475727 60572442
951517531 1800048169 868898709
1820416240 951517531 179208221
1999624461 2668946878 219310925
3729279802 1515185062 184724042
2218935386 2898481077 1015522767
3234458153 2888257803 10223274

soil-to-fertilizer map:
1569885498 220184682 161941102
3711640300 872157831 344226893
1934701528 0 25420995
3394438846 2543943059 181930710
2957858493 2070565336 135870012
1416178127 25420995 36071868
1030022714 2029369539 9317803
1039340517 1216384724 133685745
695011633 382125784 335011081
2317056551 1350070469 640801942
1731826600 2887680679 151926123
0 3039606802 695011633
2030497645 2257384153 286558906
1960122523 2038687342 31877994
3576369556 2840047597 42331426
1536338434 4027621785 33547064
1452249995 3964767856 62853929
1331718081 787697785 84460046
4055867193 2882379023 5301656
3093728505 3734618435 230149421
1173026262 61492863 158691819
1883752723 2206435348 50948805
3618700982 2725873769 92939318
1515103924 2818813087 21234510
1992000517 1990872411 38497128
3323877926 717136865 70560920

fertilizer-to-water map:
898769374 211542615 277361469
2901739042 2299030230 213178977
207924763 1114173904 26774777
3752402183 1968349402 71176470
1176130843 625299169 68863743
3114918019 3783121220 137843736
1244994586 488904084 103878858
3252761755 2915409726 98951129
2779748334 3652754391 121990708
3351712884 2593688676 245406043
0 1252990064 95883380
2007290234 3920964956 325008750
3823578653 2039525872 202532901
2443486939 2512209207 81479469
4231974038 3371954615 62993258
3698239076 2242058773 54163107
2340675105 3014360855 102811834
4219112930 4245973706 12861108
4026111554 2839094719 76315007
3597118927 3434947873 101120149
2332298984 3774745099 8376121
95883380 1140948681 112041383
4102426561 3536068022 116686369
1968349402 2296221880 2808350
1971157752 4258834814 36132482
866253147 592782942 32516227
446242155 694162912 420010992
2524966408 3117172689 254781926
234699540 0 211542615

water-to-light map:
3564276417 3073533986 256027539
540951899 3329561525 136112599
3123682450 3465674124 119685876
2479417373 4222809437 72157859
1957776831 2195006920 74795586
3089045940 3585360000 28951457
3820985109 2269802506 288781515
1285562478 1664965131 530041789
234319697 234026754 79806762
3243368326 1344057040 320908091
3117997397 541633052 5685053
2551575232 547318105 349893979
3820303956 540951899 681153
0 369583040 292943
314126459 313833516 55749524
4109766624 2888333314 185200672
292943 0 234026754
677064498 3614311457 608497980
2032572417 897212084 446844956
2901469211 2700756585 187576729
1815604267 2558584021 142172564

light-to-temperature map:
2658328410 4044901271 250066025
866264123 157899985 185676775
2062023507 343576760 307684950
1535723010 981670684 313982539
3292868240 2534053678 579746095
3905180794 3703329819 341571452
2908394435 3318856014 384473805
1194970869 1601263273 340752141
427693043 1299669198 158564104
748173107 651261710 118091016
1051940898 1458233302 143029971
586257147 0 157899985
4246752246 2485838628 48215050
1849705549 769352726 212317958
0 2368902754 805703
744157132 1295653223 4015975
805703 1942015414 426887340
3872614335 3113799773 32566459
2485838628 3146366232 172489782

temperature-to-humidity map:
2731357374 2535823037 72664015
2987243945 1266132780 17518070
3983567677 3876954134 113067367
1669770178 435765631 9597802
192217183 2087059527 132586479
324803662 1449340061 36910958
82239523 1283650850 47718149
4251710314 3400860374 43256982
788691045 2012848120 74211407
139712452 383260900 52504731
1679367980 1064470362 18439862
3627675589 3649605531 101947626
1761484189 1024489895 39980467
3964889474 4132263773 7628253
469056934 1486251019 222779936
3808503415 3992550600 118386133
4096635044 4139892026 155075270
0 328658745 54602155
3929418647 3751553157 35470827
3729623215 3787023984 78880200
129957672 2003093340 9754780
3926889548 3990021501 2529099
2130123401 3260061108 28438224
1154320063 445363433 515450115
2331952939 1331368999 72869773
2804021389 1082910224 183222556
1140184340 2219646006 14135723
3606348549 4110936733 21327040
3004762015 1709030955 50302777
1801464656 0 328658745
691836870 1759333732 96854175
447785309 2608487052 21271625
3400860374 3444117356 205488175
3055064792 2233781729 261071908
2185047506 1856187907 146905433
1697807842 960813548 63676347
361714620 2494853637 40969400
2404822712 2933526446 326534662
402684020 1404238772 45101289
3972517727 3865904184 11049950
2158561625 2907040565 26485881
862902452 2629758677 277281888
54602155 3288499332 27637368

humidity-to-location map:
1368371614 3063096196 39876417
2318920763 3734391855 138926764
2980019498 3984955289 310012007
3732521234 1430493364 562446062
213274662 484132485 78936678
0 892307918 213274662
1023610211 575518293 214768297
2807160244 2776517513 21582263
2457847527 2833630022 176634966
3619027057 2663023336 113494177
2926107621 1368371614 53911877
1784866635 3524616139 209775716
2695523574 3873318619 111636670
1250827638 790286590 102021328
3290031505 1992939426 224427328
954760770 415283044 68849441
1408248031 2286404732 376618604
292211340 0 415283044
1994642351 3102972613 324278412
2642692366 3034347120 28749076
3514458833 2798099776 35530246
1238378508 563069163 12449130
2828742507 3427251025 97365114
3549989079 2217366754 69037978
2671441442 3010264988 24082132
707494384 1105582580 247266386
2634482493 1422283491 8209873
