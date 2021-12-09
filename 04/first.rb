# frozen_string_literal: true

require('pry')
require_relative('../read_file')

class Board
  attr_accessor(:won)

  def initialize
    @rows = []
    @columns = []
    @lines = []
    @total = 0
    @won = false
  end

  def add_row(row)
    @rows << row

    row.each_with_index do |row_val, idx|
      @total += row_val
      @columns[idx] = [] if @columns[idx].nil?
      @columns[idx] << row_val
    end

    @lines = @rows + @columns if @rows.length == 5
  end

  def mark_number(number)
    hit = false
    @lines.each do |line|
      result = line.delete(number)
      next if result.nil?

      hit = true
      if line.length.zero?
        @won = true
        return (@total - number) * number
      end
    end
    @total -= number if hit
    nil
  end
end

numbers = []
boards = []

FileReader.for_each_in('./input') do |line|
  if numbers.length.zero?
    numbers = line.split(',').map(&:to_i)
    next
  end

  if line == "\n"
    boards << Board.new
  else
    boards.last.add_row(line.split.map(&:to_i))
  end
end

score = 0
numbers.each do |number|
  boards.each do |board|
    result = board.mark_number(number)
    unless result.nil?
      score = result
      break
    end
  end
  break if score != 0
end

puts score
