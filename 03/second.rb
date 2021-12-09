# frozen_string_literal: true

require('pry')
require_relative('../read_file')

def parse_line(line)
  converted = line.chars.map(&:to_i)
  converted.pop
  converted
end

def filter(inputs, more_or_less, depth = 0)
  ones = []
  zeros = []

  inputs.each do |input|
    if input[depth] == 1
      ones << input
    else
      zeros << input
    end
  end

  if ones.length == zeros.length
    if ones.length == 1
      return more_or_less ? ones : zeros
    end

    filter(more_or_less ? ones : zeros, more_or_less, depth + 1)
  elsif ones.length > zeros.length
    if ones.length == 1
      return more_or_less ? ones : zeros
    end

    filter(more_or_less ? ones : zeros, more_or_less, depth + 1)
  else
    if zeros.length == 1
      return more_or_less ? zeros : ones
    end

    filter(more_or_less ? zeros : ones, more_or_less, depth + 1)
  end
end

def compute_bcd(bin_array)
  total = 0
  bin_array.each_with_index do |value, idx|
    total += value * (2**(12 - idx - 1))
  end
  total
end

inputs = []
FileReader.for_each_in('./input') do |line|
  inputs << parse_line(line)
end

o2_bin = filter(inputs, true)[0]
co2_bin = filter(inputs, false)[0]

puts compute_bcd(o2_bin) * compute_bcd(co2_bin)
