# frozen_string_literal: true

require('pry')
require_relative('../read_file')

grid = []

FileReader.for_each_in('./input') do |line|
  grid << line.gsub("\n", '').chars.map(&:to_i)
end

def increase_energy(grid, x, y)
  return 0 if x > 9 || y > 9 || x < 0 || y < 0

  flashes = 0
  if grid[x][y] == 9
    flashes = 1
    grid[x][y] = -1
    flashes += increase_energy(grid, x, y + 1)
    flashes += increase_energy(grid, x + 1, y)
    flashes += increase_energy(grid, x - 1, y)
    flashes += increase_energy(grid, x, y - 1)
    flashes += increase_energy(grid, x + 1, y + 1)
    flashes += increase_energy(grid, x - 1, y - 1)
    flashes += increase_energy(grid, x + 1, y - 1)
    flashes += increase_energy(grid, x - 1, y + 1)
  else
    grid[x][y] += 1 unless grid[x][y].negative?
  end
  flashes
end

flash_count = 0
sim_flashes = []
(1..100).each do |step|
  grid.each_with_index do |row, x|
    row.each_with_index do |_, y|
      flash_count += increase_energy(grid, x, y) unless grid[x][y] == -1
    end
  end

  grid.each_with_index do |row, x|
    row.each_with_index do |point, y|
      grid[x][y] += 1 if point == -1
    end
  end
end

puts flash_count
