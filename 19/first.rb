# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

Instrument.time do
  scanners = []
  FileReader.for_each_in('./sample') do |line|
    next if line == "\n"

    if line.chars[0] == '-' && line.chars[1] == '-'
      scanners << []
      next
    end

    coords = line.split(',').map(&:to_i)
    mag = 0
    coords.each do |coord|
      mag += coord * coord
    end
    mag = Math.sqrt(mag)

    scanners.last << mag.to_i
  end

  binding.pry
end
