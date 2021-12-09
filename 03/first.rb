# frozen_string_literal: true

require('pry')
require_relative('../read_file')

binary_length = 12
counts = []
counts.fill(0, 0..binary_length - 1)
total_records = 0

def parse_line(line)
  converted = line.chars.map(&:to_i)
  converted.pop
  converted
end

FileReader.for_each_in('./input') do |line|
  input = parse_line(line)

  counts = [input, counts].transpose.map { |x| x.reduce(:+) }
  total_records += 1
end

gamma = 0
epsilon = 0
counts.each_with_index do |count, idx|
  if count > total_records / 2
    gamma += 2**(binary_length - idx - 1)
  else
    epsilon += 2**(binary_length - idx - 1)
  end
end

puts gamma * epsilon
