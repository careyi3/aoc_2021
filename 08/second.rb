# frozen_string_literal: true

require('pry')
require_relative('../read_file')

sum = 0
FileReader.for_each_in('./input') do |line| # rubocop:disable Metrics/BlockLength
  input_sequences = line.split('|')[0].split.sort_by(&:length)
  output_sequences = line.split('|')[1].split
  map = {}
  input_sequences.each do |input| # rubocop:disable Metrics/BlockLength
    if input.length == 2
      map[1] = input.chars.sort.join
      next
    end
    if input.length == 3
      map[7] = input.chars.sort.join
      next
    end
    if input.length == 4
      map[4] = input.chars.sort.join
      next
    end
    if input.length == 7
      map[8] = input.chars.sort.join
      next
    end
    if input.length == 5
      if (map[1].chars - input.chars).empty?
        map[3] = input.chars.sort.join
        next
      end
      if (input.chars - map[4].chars).length == 3
        map[2] = input.chars.sort.join
        next
      end
      if (input.chars - map[4].chars).length == 2
        map[5] = input.chars.sort.join
        next
      end
    else
      if (input.chars - map[7].chars).length == 4
        map[6] = input.chars.sort.join
        next
      end
      if (input.chars - (map[4].chars + map[7].chars).uniq).length == 1
        map[9] = input.chars.sort.join
        next
      end
      if (input.chars - (map[4].chars + map[7].chars).uniq).length == 2
        map[0] = input.chars.sort.join
        next
      end
    end
  end

  output_num = ''
  map = map.invert
  output_sequences.each do |output|
    output_num += map[output.chars.sort.join].to_s
  end
  sum += output_num.to_i
end

puts sum