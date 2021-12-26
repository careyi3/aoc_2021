# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

# rubocop:disable Metrics/BlockNesting, Style/CombinableLoops
Instrument.time do
  grid = {}
  y = 0
  x_max = 0
  FileReader.for_each_in('./input') do |line|
    chars = line.gsub("\n", '').chars
    x_max = chars.length - 1
    chars.each_with_index do |val, x|
      grid["#{x},#{y}"] = { val: val, e_step: -1, s_step: -1 }
    end
    y += 1
  end

  y_max = y - 1

  move = true
  step = 0
  while move
    move = false

    grid.each do |key, val|
      x, y = key.split(',').map(&:to_i)
      next if val[:val] == '.' || val[:e_step] == step

      if val[:val] == '>'
        if x + 1 <= x_max
          if grid["#{x + 1},#{y}"][:val] == '.' && grid["#{x + 1},#{y}"][:e_step] < step
            grid["#{x},#{y}"] = { val: '.', e_step: step, s_step: val[:s_step] }
            grid["#{x + 1},#{y}"] = { val: '>', e_step: step, s_step: val[:s_step] }
            move = true
          end
        else
          if grid["0,#{y}"][:val] == '.' && grid["0,#{y}"][:e_step] < step
            grid["#{x},#{y}"] = { val: '.', e_step: step, s_step: val[:s_step] }
            grid["0,#{y}"] = { val: '>', e_step: step, s_step: val[:s_step] }
            move = true
          end
        end
      end
    end

    grid.each do |key, val|
      x, y = key.split(',').map(&:to_i)
      next if val[:val] == '.' || val[:s_step] == step

      if val[:val] == 'v'
        if y + 1 <= y_max
          if grid["#{x},#{y + 1}"][:val] == '.' && grid["#{x},#{y + 1}"][:s_step] < step
            grid["#{x},#{y}"] = { val: '.', s_step: step, e_step: val[:e_step] }
            grid["#{x},#{y + 1}"] = { val: 'v', s_step: step, e_step: val[:e_step] }
            move = true
          end
        else
          if grid["#{x},0"][:val] == '.' && grid["#{x},0"][:s_step] < step
            grid["#{x},#{y}"] = { val: '.', s_step: step, e_step: val[:e_step] }
            grid["#{x},0"] = { val: 'v', s_step: step, e_step: val[:e_step] }
            move = true
          end
        end
      end
    end

    step += 1
  end

  puts step
end
