# frozen_string_literal: true

require('pry')
require('matrix')
require_relative('../read_file')
require_relative('../instrument')

Instrument.time do
  grid = {}
  steps = 0
  FileReader.for_each_in('./sample') do |line|
    command, ranges = line.split

    state = command == 'on' ? 1 : 0
    vectors = ranges.split(',')

    (eval(vectors[0])).each do |x|
      (eval(vectors[1])).each do |y|
        (eval(vectors[2])).each do |z|
          grid["#{x},#{y},#{z}"] = state
        end
      end
    end
    steps += 1
    puts steps
  end

  puts grid.values.sum
end
