# frozen_string_literal: true

require('pry')
require_relative('../read_file')

input = FileReader.read_file('./sample')

state = input.split(',').map(&:to_i)

80.times do
  fresh_fish = 0
  state.each_with_index do |fish, idx|
    if fish.zero?
      state[idx] = 6
      fresh_fish += 1
      next
    end
    state[idx] = state[idx] - 1
  end
  (0..fresh_fish - 1).each do
    state << 8
  end
end

puts state.length
