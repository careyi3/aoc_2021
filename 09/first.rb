# frozen_string_literal: true

require('pry')
require_relative('../read_file')

risk = 0
grid = []

FileReader.for_each_in('./input') do |line|
  grid << line.gsub("\n", '').chars.map(&:to_i)
end

grid.each_with_index do |row, row_idx|
  row.each_with_index do |point, idx|
    surrounding_points = []
    surrounding_points << grid[row_idx][idx + 1] unless grid[row_idx][idx + 1].nil?
    surrounding_points << grid[row_idx + 1][idx] unless grid[row_idx + 1].nil?
    surrounding_points << grid[row_idx - 1][idx] if row_idx - 1 > -1
    surrounding_points << grid[row_idx][idx - 1] if idx - 1 > -1

    if surrounding_points.compact.all? { |surrounding_point| surrounding_point > point }
      risk += point + 1
    end
  end
end

puts risk
