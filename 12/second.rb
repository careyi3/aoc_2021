# frozen_string_literal: true

require('pry')
require_relative('../read_file')
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
      next unless can_visit?(steps, node)

      step(node, steps)
      steps.pop
    end

    next_node
  end

  def can_visit?(steps, node)
    return true if node.upcase == node
    return false if node == 'start'

    visited = {}
    steps.select { |n| n == n.downcase }.each do |n|
      if visited[n].nil?
        visited[n] = 1
      else
        visited[n] += 1
      end
    end

    return true if visited[node].nil?
    return true if visited.values.sum == visited.length

    false
  end
end

map = Map.new

FileReader.for_each_in('./input') do |line|
  map.add_edge(line.gsub("\n", ''))
end

puts map.count_paths
