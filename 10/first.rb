# frozen_string_literal: true

require('pry')
require_relative('../read_file')

lookup = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25_137
}
error = 0

FileReader.for_each_in('./input') do |line|
  stack = []

  line.gsub("\n", '').chars.each do |char|
    if ['(', '<', '{', '['].include?(char)
      stack << char
    else
      popped = stack.pop
      check = "#{popped}#{char}"
      unless ['()', '<>', '{}', '[]'].include?(check)
        error += lookup[char]
        next
      end
    end
  end
end

puts error
