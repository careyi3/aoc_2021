# frozen_string_literal: true

require('pry')
require_relative('../read_file')

class Segment
  def initialize(input)
    @x1 = input[0]
    @y1 = input[1]
    @x2 = input[2]
    @y2 = input[3]
  end

  def points
    points = []
    if @x1 == @x2
      points << if @y2 > @y1
                  (@y1..@y2).map { |y| [@x1, y].to_s }
                else
                  @y1.downto(@y2).map { |y| [@x1, y].to_s }
                end
      return points.flatten
    end

    if @y1 == @y2
      points << if @x2 > @x1
                  (@x1..@x2).map { |x| [x, @y1].to_s }
                else
                  @x1.downto(@x2).map { |x| [x, @y1].to_s }
                end
      return points.flatten
    end

    x_range = @x2 > @x1 ? (@x1..@x2) : @x1.downto(@x2)
    y_range = @y2 > @y1 ? (@y1..@y2) : @y1.downto(@y2)
    ys = y_range.map { |y| y }

    x_range.each_with_index do |x, idx|
      points << [x, ys[idx]].to_s
    end

    points
  end
end

segments = []
FileReader.for_each_in('./input') do |line|
  segments << Segment.new(line.split(' -> ').map { |x| x.split(',').map(&:to_i) }.flatten)
end

flat_points = segments.map(&:points).flatten

points = {}
count = 0
flat_points.each do |point|
  if points[point].nil?
    points[point] = 1
  else
    count += 1 if points[point] == 1
    points[point] = points[point] + 1
  end
end

puts count
