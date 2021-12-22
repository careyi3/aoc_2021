# frozen_string_literal: true

require('pry')
require('matrix')
require_relative('../read_file')
require_relative('../instrument')

def t_x(rads)
  Matrix[
    [1, 0, 0],
    [0, Math.cos(rads).to_i, -Math.sin(rads).to_i],
    [0, Math.sin(rads).to_i, Math.cos(rads).to_i]
  ]
end

def t_y(rads)
  Matrix[
    [Math.cos(rads).to_i, 0, Math.sin(rads).to_i],
    [0, 1, 0],
    [-Math.sin(rads).to_i, 0, Math.cos(rads).to_i]
  ]
end

def t_z(rads)
  Matrix[
    [Math.cos(rads).to_i, -Math.sin(rads).to_i, 0],
    [Math.sin(rads).to_i, Math.cos(rads).to_i, 0],
    [0, 0, 1]
  ]
end

def transform(point)
  transforms = []
  transforms << Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]]
  transforms << Matrix[[-1, 0, 0], [0, 0, 1], [0, 1, 0]]
  transforms << Matrix[[-1, 0, 0], [0, 1, 0], [0, 0, 1]]
  transforms << Matrix[[1, 0, 0], [0, 0, 1], [0, 1, 0]]

  transforms << Matrix[[0, 0, 1], [0, 1, 0], [1, 0, 0]]
  transforms << Matrix[[0, 0, -1], [1, 0, 0], [0, 1, 0]]
  transforms << Matrix[[0, 0, -1], [0, 1, 0], [1, 0, 0]]
  transforms << Matrix[[0, 0, 1], [1, 0, 0], [0, 1, 0]]

  transforms << Matrix[[0, 1, 0], [0, 0, 1], [1, 0, 0]]
  transforms << Matrix[[0, -1, 0], [1, 0, 0], [0, 0, 1]]
  transforms << Matrix[[0, -1, 0], [0, 0, 1], [1, 0, 0]]
  transforms << Matrix[[0, 1, 0], [1, 0, 0], [0, 0, 1]]

  rotations = []
  [0, Math::PI / 2, Math::PI, 3 * Math::PI / 2].each do |rads|
    rotations << t_x(rads)
    rotations << t_y(rads)
    rotations << t_z(rads)
  end

  transformed_points = {}
  rotations.each do |rotation|
    transforms.each do |transform|
      value = (rotation * (transform * point))
      transformed_points[value] = { transformed_point: value, rotation: rotation, transform: transform }
    end
  end
  transformed_points.values
end

def finger_print(point, transformed_point)
  [(point - transformed_point[:transformed_point]).to_a.flatten.join(':'), transformed_point[:rotation], transformed_point[:transform]]
end

def process(to_check, map, idx)
  scanner = map[idx]
  map.each do |inner_key, inner_scanner|
    next if idx == inner_key || inner_scanner[:relative_to].zero?

    matches = {}
    matched = nil
    transformed_points = inner_scanner[:points].map { |point| transform(point) }.flatten
    transformed_points.each do |transformed_point|
      scanner[:points].each do |point|
        finger_print, rotation, transform = finger_print(point, transformed_point)
        if matches[finger_print].nil?
          matches[finger_print] = { finger_print: finger_print, rotation: rotation, transform: transform, count: 1 }
        else
          matches[finger_print][:count] += 1
        end
        if matches[finger_print][:count] == 12
          matched = matches[finger_print]
          break
        end
      end
    end

    next if matched.nil?

    offset = matched[:finger_print].split(':').map(&:to_i)
    coords = Matrix[[offset[0]], [offset[1]], [offset[2]]]
    rotation = matched[:rotation]
    transform = matched[:transform]

    map[inner_key][:coords] = coords
    map[inner_key][:rotation] = rotation
    map[inner_key][:transform] = transform
    map[inner_key][:relative_to] = map[idx][:relative_to]
    to_check << inner_key if map[inner_key][:relative_to].zero?
    map[inner_key][:points].each_with_index do |point, idxx|
      map[inner_key][:points][idxx] = coords + (rotation * (transform * point))
    end
  end
end

Instrument.time do
  map = {}
  num_scanners = -1
  FileReader.for_each_in('./input') do |line|
    next if line == "\n"

    if line.chars[0] == '-' && line.chars[1] == '-'
      num_scanners += 1
      map[num_scanners] = { coords: Matrix[[0], [0], [0]], points: [], rotation: 1, transform: 1, relative_to: num_scanners }
      next
    end

    coords = line.split(',').map(&:to_i)
    map[num_scanners][:points] << Matrix[[coords[0]], [coords[1]], [coords[2]]]
  end

  to_check = [0]
  until to_check.length == map.length
    to_check.each do |idx|
      process(to_check, map, idx)
    end
  end

  puts map.values.select { |x| x[:relative_to].zero? }.map { |x| x[:points].map { |v| v.to_a.flatten.join(':') } }.flatten.uniq.count
end
