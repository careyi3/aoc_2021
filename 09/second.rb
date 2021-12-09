# frozen_string_literal: true

require('pry')
require_relative('../read_file')

grid = []

FileReader.for_each_in('./input') do |line|
  grid << line.gsub("\n", '').chars.map { |point| point.to_i == 9 ? -1 : point.to_i }
end

def walk(grid, x, y)
  grid[x][y] = -1
  steps = 1
  steps += walk(grid, x, y + 1) unless grid[x][y + 1].nil? || grid[x][y + 1] == -1
  steps += walk(grid, x + 1, y) unless grid[x + 1].nil? || grid[x + 1][y] == -1
  steps += walk(grid, x - 1, y) if x - 1 > -1 && grid[x - 1][y] > -1
  steps += walk(grid, x, y - 1) if y - 1 > -1 && grid[x][y - 1] > -1

  steps
end

basin_sizes = []

grid.each_with_index do |row, row_idx|
  row.each_with_index do |point, idx|
    basin_sizes << walk(grid, row_idx, idx) if point > -1
  end
end

basin_sizes.sort!.reverse!

puts basin_sizes[0] * basin_sizes[1] * basin_sizes[2]
