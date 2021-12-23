# frozen_string_literal: true

require('pry')
require('matrix')
require_relative('../read_file')
require_relative('../instrument')

class Cuboid
  def initialize(x_min, x_max, y_min, y_max, z_min, z_max)
    @x_max = x_max
    @x_min = x_min
    @y_max = y_max
    @y_min = y_min
    @z_max = z_max
    @z_min = z_min
  end

  def to_s
    "(#{@x_min}, #{@x_max}, #{@y_min}, #{@y_max}, #{@z_min}, #{@z_max})"
  end

  def hash
    to_s.hash
  end

  def vector
    [@x_min, @x_max, @y_min, @y_max, @z_min, @z_max]
  end

  def intersection(x_min, x_max, y_min, y_max, z_min, z_max)
    Cuboid.new(
      [x_min, @x_min].max,
      [x_max, @x_max].min,
      [y_min, @y_min].max,
      [y_max, @y_max].min,
      [z_min, @z_min].max,
      [z_max, @z_max].min
    )
  end

  def intersect?(x_min, x_max, y_min, y_max, z_min, z_max)
    intersection(x_min, x_max, y_min, y_max, z_min, z_max).valid?
  end

  def valid?
    @x_max > @x_min && @y_max > @y_min && @z_max > @z_min
  end

  def volume
    (@x_max - @x_min) * (@y_max - @y_min) * (@z_max - @z_min)
  end
end

Instrument.time do
  def split_cuboids(new_cuboid, cuboids, state)
    cuboids.keys.each do |cuboid|
      next unless new_cuboid.intersect?(*cuboid.vector)

      intersection_volume = new_cuboid.intersection(*cuboid.vector).volume

      cuboids.delete(cuboid)

      xs = [cuboid.vector[0..1], new_cuboid.vector[0..1]].flatten.uniq.sort
      ys = [cuboid.vector[2..3], new_cuboid.vector[2..3]].flatten.uniq.sort
      zs = [cuboid.vector[4..5], new_cuboid.vector[4..5]].flatten.uniq.sort

      sub_cuboid_volumes = 0
      xs.each_cons(2) do |x_min, x_max|
        ys.each_cons(2) do |y_min, y_max|
          zs.each_cons(2) do |z_min, z_max|
            sub_cuboid = Cuboid.new(x_min, x_max, y_min, y_max, z_min, z_max)
            if cuboid.intersect?(*sub_cuboid.vector) && !new_cuboid.intersect?(*sub_cuboid.vector)
              sub_cuboid_volumes += sub_cuboid.volume
              cuboids[sub_cuboid] = true
            end
          end
        end
      end

      new_cuboid_volume = new_cuboid.volume
      old_cuboid_volume = cuboid.volume

      if state
        puts false unless (new_cuboid_volume + old_cuboid_volume - intersection_volume) == (new_cuboid_volume + sub_cuboid_volumes)
      else
        puts false unless (old_cuboid_volume - intersection_volume) == sub_cuboid_volumes
      end
    end
    cuboids[new_cuboid] = state if state
  end

  cuboids = {}
  FileReader.for_each_in('./input') do |line|
    command, ranges = line.split

    state = command == 'on'
    vectors = ranges.split(',')
      .map { |x| x.split('=') }
      .map { |x| x[1] }
      .map { |x| x.split }
      .flatten.map { |x| x.split('..').map(&:to_i) }

    cuboid = Cuboid.new(
      vectors[0][0],
      vectors[0][1] + 1,
      vectors[1][0],
      vectors[1][1] + 1,
      vectors[2][0],
      vectors[2][1] + 1
    )

    split_cuboids(cuboid, cuboids, state)
  end

  puts cuboids.keys.sum(&:volume)
end
