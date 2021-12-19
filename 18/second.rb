# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

Instrument.time do
  def walk(pair, depth = 0, values = [], depths = [])
    depth += 1

    pair.each do |value|
      if value.is_a?(Integer)
        values << value
        depths << depth
      else
        values, depths = walk(value, depth, values, depths)
      end
    end

    [values, depths]
  end

  def add(a_values, a_depths, b_values, b_depths)
    [a_values + b_values, (a_depths + b_depths).map { |x| x + 1 }]
  end

  def reduce(values, depths)
    op = true
    while op
      op = false
      exploded = false
      values.each_with_index do |_, idx|
        unless depths[idx] >= 5
          exploded = false
          next
        end

        values[idx - 1] += values[idx] if idx - 1 >= 0
        values[idx + 2] += values[idx + 1] if idx + 2 <= values.length - 1

        values[idx] = 0
        depths[idx] -= 1

        values.delete_at(idx + 1)
        depths.delete_at(idx + 1)
        op = true
        exploded = true
        break
      end
      next if exploded

      values.each_with_index do |val, idx|
        next unless val > 9

        values[idx] = val / 2
        depths[idx] += 1
        values.insert(idx + 1, val.odd? ? (val / 2) + 1 : val / 2)
        depths.insert(idx + 1, depths[idx])

        op = true
        break
      end
    end

    values.each

    [values, depths]
  end

  def sum(arr)
    left, right = arr.each_slice((arr.size / 2.0).round).to_a
    (3 * (left.length > 1 ? sum(left) : left[0])) + (2 * (right.length > 1 ? sum(right) : right[0]))
  end

  nums = []
  FileReader.for_each_in('./input') do |line|
    nums << eval(line.gsub("\n", ''))
  end

  sums = []
  nums.each_with_index do |outer, outer_idx|
    outer_values, outer_depths = walk(outer)
    nums.each_with_index do |inner, inner_idx|
      next if outer_idx == inner_idx

      inner_values, inner_depths = walk(inner)
      values, depths = add(outer_values, outer_depths, inner_values, inner_depths)
      values, = reduce(values, depths)
      sums << sum(values)
    end
  end

  puts sums.max
end
