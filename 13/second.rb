# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

Instrument.time do
  grid = []
  xs = []
  ys = []
  instructions = []
  read_instructions = false
  FileReader.for_each_in('./input') do |line|
    if line == "\n"
      read_instructions = true
      next
    end

    if read_instructions
      instructions << line.split.last.split('=')
    else
      xy = line.split(',').map(&:to_i)
      xs << xy[0]
      ys << xy[1]
    end
  end

  grid.fill([], 0..ys.max)
  grid.each_with_index do |_, idx|
    a = []
    a.fill(0, 0..xs.max)
    grid[idx] = a
  end

  xs.each_with_index do |x, idx|
    grid[ys[idx]][x] = 1
  end

  instructions.each do |instruction|
    amount = instruction[1].to_i
    if instruction[0] == 'x'
      grid.each_with_index do |arr, idx|
        f = arr.slice(0, amount).reverse
        s = arr.slice(amount + 1, arr.length)
        grid[idx] = [f, s].transpose.map { |x| x.reduce(:+) }
      end
    else
      f = grid.slice(0, amount).reverse
      s = grid.slice(amount + 1, grid.length)
      new_grid = []
      f.each_with_index do |arr, idx|
        new_grid << [arr, s[idx]].transpose.map { |x| x.reduce(:+) }
      end
      grid = new_grid
    end
  end

  grid.each_with_index do |arr, idx_1|
    arr.each_with_index do |val, idx_2|
      grid[idx_1][idx_2] =
        if val.positive?
          1
        else
          ' '
        end
    end
    grid[idx_1] = grid[idx_1].reverse
  end

  grid = grid.reverse

  puts grid.map { |x| x.join(' ') }
end
