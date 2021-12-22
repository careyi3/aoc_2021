# frozen_string_literal: true

require('pry')
require_relative('../read_file')
require_relative('../instrument')

Instrument.time do
  start_positions = []
  FileReader.for_each_in('./input') do |line|
    start_positions << line.split(':')[1].to_i
  end

  def play(turn, p1_score, p1_position, p2_score, p2_position, wins) # rubocop:disable Metrics/ParameterLists
    return 1, 0 if p1_score > 20
    return 0, 1 if p2_score > 20

    key = "#{turn}:p1s#{p1_score}:p1p#{p1_position}:p2s#{p2_score}:p2p#{p2_position}"
    return wins[key] unless wins[key].nil?

    player1_wins = 0
    player2_wins = 0

    if turn
      [3, 4, 5, 4, 5, 6, 5, 6, 7, 4, 5, 6, 5, 6, 7, 6, 7, 8, 5, 6, 7, 6, 7, 8, 7, 8, 9].each do |num|
        pos = ((p1_position + num - 1) % 10) + 1
        p1w, p2w = play(false, p1_score + pos, pos, p2_score, p2_position, wins)
        player1_wins += p1w
        player2_wins += p2w
      end
    else
      [3, 4, 5, 4, 5, 6, 5, 6, 7, 4, 5, 6, 5, 6, 7, 6, 7, 8, 5, 6, 7, 6, 7, 8, 7, 8, 9].each do |num|
        pos = ((p2_position + num - 1) % 10) + 1
        p1w, p2w = play(true, p1_score, p1_position, p2_score + pos, pos, wins)
        player1_wins += p1w
        player2_wins += p2w
      end
    end

    wins[key] = [player1_wins, player2_wins]
    [player1_wins, player2_wins]
  end

  p1_position = start_positions[0]
  p2_position = start_positions[1]

  puts play(true, 0, p1_position, 0, p2_position, {}).max
end
