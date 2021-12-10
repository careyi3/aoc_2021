# frozen_string_literal: true

require('pry')
require_relative('../read_file')

lookup = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
}

scores = []

FileReader.for_each_in('./input') do |line|
  stack = []
  error = false
  line.gsub("\n", '').chars.each do |char|
    if ['(', '<', '{', '['].include?(char)
      stack << char
    else
      popped = stack.pop
      check = "#{popped}#{char}"
      unless ['()', '<>', '{}', '[]'].include?(check)
        error = true
        break
      end
    end
  end

  unless error
    score = 0
    stack.reverse.each do |symbol|
      score *= 5
      score += lookup[symbol]
    end
    scores << score
  end
end

puts scores.sort[scores.length / 2]
