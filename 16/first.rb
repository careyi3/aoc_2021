# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

hex_map = {
  '0' => '0000',
  '1' => '0001',
  '2' => '0010',
  '3' => '0011',
  '4' => '0100',
  '5' => '0101',
  '6' => '0110',
  '7' => '0111',
  '8' => '1000',
  '9' => '1001',
  'A' => '1010',
  'B' => '1011',
  'C' => '1100',
  'D' => '1101',
  'E' => '1110',
  'F' => '1111'
}

Instrument.time do
  hex = FileReader.read_file('./input')

  bin = hex.chars.map { |char| hex_map[char] }.join.chars

  packets = []

  def bcd_to_int(bcd)
    int = 0
    bcd.reverse.each_with_index do |char, index|
      int += char.to_i * (2**index)
    end
    int
  end

  def read(bin, packets, nested = false)
    version = bcd_to_int(bin[0..2])
    bin.shift(3)
    type = bcd_to_int(bin[0..2])
    bin.shift(3)
    shift_count = 6
    packet = {
      version: version,
      type: type,
      length_type: type == 4 ? nil : bin.shift.to_i,
      sub_packets: []
    }
    if packet[:type] == 4
      chars = []
      until bin[0].to_i.zero?
        chars << bin[1..4]
        bin.shift(5)
        shift_count += 5
      end
      chars << bin[1..4]
      shift_count += 5
      bin.shift(5)
      packet[:value] = bcd_to_int(chars.flatten)
    else
      shift_count += 1
      if packet[:length_type].zero?
        bit_length = bcd_to_int(bin[0..14])
        bin.shift(15)
        shift_count += 15
        inner_shift_count_accum = 0
        while inner_shift_count_accum < bit_length
          bin, packet[:sub_packets], inner_shift_count = read(bin, packet[:sub_packets], true)
          shift_count += inner_shift_count
          inner_shift_count_accum += inner_shift_count
        end
      else
        num_packets = bcd_to_int(bin[0..10])
        bin.shift(11)
        shift_count += 11
        num_packets.times do
          bin, packet[:sub_packets], inner_shift_count = read(bin, packet[:sub_packets], true)
          shift_count += inner_shift_count
        end
      end
    end
    unless (shift_count % 4).zero? || nested
      if shift_count.odd?
        bin.shift(4 - (shift_count % 4))
        shift_count += 4 - (shift_count % 4)
      else
        bin.shift(shift_count % 4)
        shift_count += shift_count % 4
      end
    end
    packets << packet
    [bin, packets, shift_count]
  end

  bin, packets = read(bin, packets) until bin.length.zero?

  def version_sum(packet)
    sum = packet[:version]
    packet[:sub_packets].each do |sub_packet|
      sum += version_sum(sub_packet)
    end
    sum
  end

  sum = 0
  packets.each do |packet|
    sum += version_sum(packet)
  end

  puts sum
end
