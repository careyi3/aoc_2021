# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

Instrument.time do
  start_positions = []
  FileReader.for_each_in('./input') do |line|
    start_positions << line.split(':')[1].to_i
  end

  player1_position = start_positions[0]
  player2_position = start_positions[1]

  player1_score = 0
  player2_score = 0

  rolls = 0
  player1 = true
  die = 1
  until player1_score >= 1000 || player2_score >= 1000
    values = []
    3.times do
      values << die
      die += 1
      die = (die % 100).zero? ? 100 : die % 100
      rolls += 1
    end
    move = values.sum

    if player1
      player1_position += move
      player1_position = (player1_position % 10).zero? ? 10 : player1_position % 10
      player1_score += player1_position
    else
      player2_position += move
      player2_position = (player2_position % 10).zero? ? 10 : player2_position % 10
      player2_score += player2_position
    end
    player1 = !player1
  end

  puts [player1_score, player2_score].min * rolls
end
