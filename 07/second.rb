# frozen_string_literal: true

require('./day7')

Day7.algo do |x, y|
  n = (x - y).abs
  ((n * (n + 1)) / 2)
end
