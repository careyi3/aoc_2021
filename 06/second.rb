# frozen_string_literal: true

require('pry')
require_relative('../read_file')

input = FileReader.read_file('./input')

state_arr = input.split(',').map(&:to_i)

state = { 0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0 }

state_arr.each do |val|
  state[val] = state[val] + 1
end

256.times do
  zeros = state[0]
  (0..8).each do |num|
    if num == 8
      state[num] = zeros
      next
    end
    state[num] = if num == 6
                   state[num + 1] + zeros
                 else
                   state[num + 1]
                 end
  end
end

puts state.values.sum
