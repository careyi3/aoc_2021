# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

Instrument.time do
  rules = {}
  elements = {}
  sequence = ''

  FileReader.for_each_in('./input') do |line|
    next if line == "\n"

    if sequence == ''
      sequence = line.gsub("\n", '')
    else
      rules[line.split(' -> ')[0].gsub("\n", '')] = line.split(' -> ')[1].gsub("\n", '')
    end
  end

  sequence.chars.each do |char|
    if elements[char].nil?
      elements[char] = 1
    else
      elements[char] += 1
    end
  end

  10.times do
    new_sequence = ''
    sequence.chars.each_with_index do |char, idx|
      if sequence[idx + 1].nil?
        new_sequence += char
        break
      end

      pair = char + sequence[idx + 1]

      new_sequence += char + rules[pair]

      if elements[rules[pair]].nil?
        elements[rules[pair]] = 1
      else
        elements[rules[pair]] += 1
      end
    end
    sequence = new_sequence
  end

  puts elements.values.max - elements.values.min
end
