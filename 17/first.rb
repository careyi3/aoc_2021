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
    attempt =
      {
        x_v: x_v,
        y_v: y_v,
        height: 0,
        hit: nil,
        under_over: nil
      }

    x = 0
    y = 0
    highest = 0
    hit = false
    while x <= x_max && y >= y_min
      x += x_v
      y += y_v
      highest = y if y > highest
      x_v -= 1 unless x_v.zero?
      y_v -= 1

      if x >= x_min && x <= x_max && y >= y_min && y <= y_max
        hit = true
        break
      end
    end

    attempt[:under_over] = x < x_min unless hit
    attempt[:hit] = hit
    attempt[:height] = highest
    attempt
  end

  attempts = {}
  highest = 0
  x_v = 2
  y_v = 2
  10000.times do
    attempt = fire(x_v, y_v, min_max)
    attempts["#{x_v},#{y_v}"] = attempt

    if attempt[:hit]
      highest = attempt[:height] if attempt[:height] > highest
      x_v += [-1, 1].sample
      y_v += [-1, 1].sample
      next
    end

    if attempt[:under_over]
      x_v += x_v / [4, 2].sample
      y_v += y_v / [4, 2].sample
    else
      x_v -= x_v / [4, 2].sample
      y_v -= y_v / [4, 2].sample
    end
  end

  puts highest
end
