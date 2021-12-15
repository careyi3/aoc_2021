# frozen_string_literal: true

require('algorithms')
require('pry')
require_relative('../read_file')
require_relative('../instrument')

include Containers

Instrument.time do
  grid = []
  map = {}
  heap = MinHeap.new

  FileReader.for_each_in('./input') do |line|
    grid << line.gsub("\n", '').chars.map(&:to_i)
  end

  size = 100

  grid.each_with_index do |row, x|
    row.each_with_index do |risk, y|
      (0..4).each do |x_offset|
        (0..4).each do |y_offset|
          nodes = []
          nodes << "#{x + (x_offset * size)},#{y + (y_offset * size) + 1}" if y + (y_offset * size) + 1 != grid[0].length + (4 * size)
          nodes << "#{x + (x_offset * size) + 1},#{y + (y_offset * size)}" if x + (x_offset * size) + 1 != grid.length + (4 * size)
          nodes << "#{x + (x_offset * size) - 1},#{y + (y_offset * size)}" if x + (x_offset * size) - 1 != -1
          nodes << "#{x + (x_offset * size)},#{y + (y_offset * size) - 1}" if y + (y_offset * size) - 1 != -1

          new_risk = x_offset + y_offset + risk
          new_risk = (new_risk % 10) + 1 if new_risk > 9
          map["#{x + (x_offset * size)},#{y + (y_offset * size)}"] =
            {
              key: "#{x + (x_offset * size)},#{y + (y_offset * size)}",
              risk: new_risk,
              nodes: nodes,
              path_risk: nil,
              visited: false
            }
        end
      end
    end
  end

  def walk(map, heap, key)
    current_node = map[key]
    current_node[:visited] = true

    current_node[:nodes].each do |node|
      next if map[node][:visited]

      new_risk = (current_node[:path_risk].nil? ? 0 : current_node[:path_risk]) + map[node][:risk]

      if map[node][:path_risk].nil? || new_risk < map[node][:path_risk]
        map[node][:path_risk] = new_risk
        heap.push(new_risk, node)
      end
    end

    heap.pop
  end

  next_node = '0,0'
  until next_node.nil?
    next_node = walk(map, heap, next_node)
    break if next_node.nil?
  end

  puts map['499,499'][:path_risk]
end
