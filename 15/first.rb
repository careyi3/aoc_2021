# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

Instrument.time do
  grid = []
  map = {}

  FileReader.for_each_in('./input') do |line|
    grid << line.gsub("\n", '').chars.map(&:to_i)
  end

  grid.each_with_index do |row, x|
    row.each_with_index do |risk, y|
      nodes = []

      nodes << "#{x},#{y + 1}" if y + 1 != grid[0].length
      nodes << "#{x + 1},#{y}" if x + 1 != grid.length
      nodes << "#{x - 1},#{y}" if x - 1 != -1
      nodes << "#{x},#{y - 1}" if y - 1 != -1

      map["#{x},#{y}"] = { key: "#{x},#{y}", risk: risk, visited: false, nodes: nodes, path_risk: nil }
    end
  end

  def walk(map, key)
    current_node = map[key]
    current_node[:visited] = true

    current_node[:nodes].each do |node|
      next if map[node][:visited]

      new_risk = (current_node[:path_risk].nil? ? 0 : current_node[:path_risk]) + map[node][:risk]

      map[node][:path_risk] = new_risk if map[node][:path_risk].nil? || new_risk < map[node][:path_risk]
    end

    unvisited = map.values.reject { |node| node[:visited] || node[:path_risk].nil? }.sort_by { |node| node[:path_risk] }
    return if unvisited.length.zero?

    unvisited[0][:key]
  end

  next_node = '0,0'
  until next_node.nil?
    next_node = walk(map, next_node)
    break if next_node.nil?
  end

  puts map['99,99'][:path_risk]
end
