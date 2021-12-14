# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

Instrument.time do
  rules = {}
  elements = {}
  state = {}
  start_sequence = ''

  FileReader.for_each_in('./input') do |line|
    next if line == "\n"

    if start_sequence == ''
      start_sequence = line.gsub("\n", '')
    else
      rules[line.split(' -> ')[0].gsub("\n", '')] = line.split(' -> ')[1].gsub("\n", '')
    end
  end

  start_sequence.chars.each_with_index do |char, idx|
    if start_sequence[idx + 1].nil?
      if elements[char].nil?
        elements[char] = 1
      else
        elements[char] += 1
      end
      break
    end

    pair = char + start_sequence[idx + 1]

    if state[pair].nil?
      state[pair] = 1
    else
      state[pair] += 1
    end

    if elements[char].nil?
      elements[char] = 1
    else
      elements[char] += 1
    end
  end

  40.times do
    new_state = {}
    state.each do |key, value|
      new_char = rules[key]

      if elements[new_char].nil?
        elements[new_char] = value
      else
        elements[new_char] += value
      end

      new_pair_1 = key.chars[0] + new_char
      new_pair_2 = new_char + key.chars[1]

      if new_state[new_pair_1].nil?
        new_state[new_pair_1] = value
      else
        new_state[new_pair_1] += value
      end

      if new_state[new_pair_2].nil?
        new_state[new_pair_2] = value
      else
        new_state[new_pair_2] += value
      end
    end
    state = new_state
  end

  puts elements.values.max - elements.values.min
end
