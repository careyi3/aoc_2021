# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

Instrument.time do
  line = FileReader.read_file('./input')
  min_max = line.split[2..3].map { |x| x.gsub(',', '').split('=')[1].split('..').map(&:to_i) }.flatten

  def fire(x_v, y_v, min_max)
    x_min = min_max[0]
    x_max = min_max[1]
    y_min = min_max[2]
    y_max = min_max[3]

    x = 0
    y = 0
    highest = 0
    hit = false
    while x <= x_max && y >= y_min
      x += x_v
      y += y_v
      highest = y if y > highest
      unless x_v.zero?
        if x_v.positive?
          x_v -= 1
        else
          x_v += 1
        end
      end
      y_v -= 1

      if x >= x_min && x <= x_max && y >= y_min && y <= y_max
        hit = true
        break
      end
    end

    hit
  end

  limit = 600
  count = 0
  (-limit..limit).each do |x_v|
    (-limit..limit).each do |y_v|
      count += 1 if fire(x_v, y_v, min_max)
    end
  end

  puts count
end
