# frozen_string_literal: true

require('pry')
require_relative('../read_file')

series = []
last_sum = 0
sum = 0
count = 0
FileReader.for_each_in('./input') do |line|
  next_number = line.to_i

  if series.length < 3
    series.unshift(next_number)
    next
  end

  last_sum = series.sum
  series.unshift(next_number)
  series.pop
  sum = series.sum

  count += 1 if sum > last_sum && last_sum.positive?
end

puts count
