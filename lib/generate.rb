require 'date'
require 'erb'

if ARGV.size < 2
  puts 'Usage: ruby lib/generate.rb <class> <method>'
  exit -1
end

year = ENV['YEAR'] || Date.today.year
day = (ENV['DAY'] || Date.today.day.to_s).rjust(2, '0')
class_name = ARGV[0]
method_name = ARGV[1]
dasherize = class_name.gsub(/([A-Z])/, '-\1').downcase
require_name = "#{year}/day-#{day}#{dasherize}"
file_name = "lib/#{require_name}.rb"
test_file_name = "test/#{year}/test-day-#{day}#{dasherize}.rb"

template = File.open('lib/template.erb', &:read)
test_template = File.open('test/template.erb', &:read)

puts file_name
puts test_file_name

$stdout.reopen(file_name, 'w')
ERB.new(template).run
$stdout.reopen(test_file_name, 'w')
ERB.new(test_template).run
