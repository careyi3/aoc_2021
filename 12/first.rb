# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

class Map
  attr_reader(:nodes, :paths)

  def initialize
    @nodes = {}
    @paths = []
  end

  def add_edge(edge)
    nodes = edge.split('-')
    nodes.each do |node|
      other_node = nodes.reject { |n| n == node }[0]

      if @nodes[node].nil?
        @nodes[node] = [other_node]
      else
        @nodes[node] << other_node
      end
    end
  end

  def count_paths
    step('start')
    @paths.length
  end

  private

  def step(next_node, steps = [])
    steps << next_node
    if next_node == 'end'
      @paths << steps.clone
      return next_node
    end

    @nodes[next_node].each do |node|
      next if node.downcase == node && steps.include?(node)

      step(node, steps)
      steps.pop
    end

    next_node
  end
end

Instrument.time do
  map = Map.new

  FileReader.for_each_in('./input') do |line|
    map.add_edge(line.gsub("\n", ''))
  end

  puts map.count_paths
end
