# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

Instrument.time do
  sequence = []
  grid_size = 120
  grid = Array.new(grid_size) { Array.new(grid_size, '.') }

  x_offset = 5
  y_offset = 5
  FileReader.for_each_in('./input') do |line|
    if sequence.length.zero?
      sequence = line.gsub("\n", '').chars
      next
    end
    next if line == "\n"

    line.gsub("\n", '').chars.each_with_index do |val, idx|
      grid[y_offset][x_offset + idx] = val if val == '#'
    end
    y_offset += 1
  end

  def bcd_decode(bcd)
    int = 0
    bcd.reverse.each_with_index do |num, idx|
      int += num * (2**idx)
    end
    int
  end

  grid.each do |row|
    puts row.join
  end
  puts

  grid_copy = Marshal.load(Marshal.dump(grid))
  ittr = 1
  2.times do
    (1..grid_size - 2).each do |y|
      (1..grid_size - 2).each do |x|
        seq = ''
        seq += "#{grid[y - 1][x - 1]}#{grid[y - 1][x]}#{grid[y - 1][x + 1]}"
        seq += "#{grid[y][x - 1]}#{grid[y][x]}#{grid[y][x + 1]}"
        seq += "#{grid[y + 1][x - 1]}#{grid[y + 1][x]}#{grid[y + 1][x + 1]}"
        bcd = seq.chars.map { |char| char == '#' ? 1 : 0 }
        idx = bcd_decode(bcd)
        grid_copy[y][x] = sequence[idx]
      end
    end

    pad_char = ittr.odd? ? '#' : '.'
    grid_copy.each do |row|
      row[0] = pad_char
      row[grid_size - 1] = pad_char
    end
    grid_copy[0] = Array.new(grid_size, pad_char)
    grid_copy[grid_size - 1] = Array.new(grid_size, pad_char)
    ittr += 1

    grid = Marshal.load(Marshal.dump(grid_copy))

    grid.each do |row|
      puts row.join
    end
    puts
  end

  puts grid.flatten.select { |node| node == '#' }.length
end
