# frozen_string_literal: true

require('pry')
require_relative('../read_file')

module Day7
  def self.algo
    input = FileReader.read_file('./input')

    positions = input.split(',').map(&:to_i)

    min = positions.min
    max = positions.max
    mean = ((max - min) / 2).to_i
    lower = mean - (mean / 1.5).to_i
    upper = mean + (mean / 1.5).to_i
    cost = {}

    positions.each do |position|
      (lower..upper).each do |new_position|
        cost[new_position] =
          if cost[new_position].nil?
            yield(position, new_position)
          else
            cost[new_position] + yield(position, new_position)
          end
      end
    end

    puts cost.values.min
  end
end
