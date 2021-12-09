# frozen_string_literal: true

require('pry')
require_relative('../read_file')

last_number = nil
count = 0
FileReader.for_each_in('./input') do |line|
  next_number = line.to_i
  if last_number.nil?
    last_number = next_number
    next
  end

  count += 1 if next_number > last_number
  last_number = next_number
end

puts count
