# frozen_string_literal: true

require('pry')
require_relative('../read_file')

count = 0
FileReader.for_each_in('./input') do |line|
  sequences = line.split('|')[1].split
  count += sequences.select { |sequence| sequence.length == 7 || sequence.length < 5 }.count
end

puts count
