# frozen_string_literal: true

require('pry')
require_relative('../read_file')

depth = 0
horizontal = 0

commands = {
  'forward' => ->(input) { horizontal += input },
  'down' => ->(input) { depth += input },
  'up' => ->(input) { depth -= input }
}

def parse_instruction(instruction)
  command_input = instruction.split

  [command_input[0], command_input[1].to_i]
end

FileReader.for_each_in('./input') do |instruction|
  command, input = parse_instruction(instruction)

  commands[command].call(input)
end

puts depth * horizontal
