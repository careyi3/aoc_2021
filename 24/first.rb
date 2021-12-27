# frozen_string_literal: true

require('pry')
require('matrix')
require_relative('../read_file')
require_relative('../instrument')

class ALU
  COMMANDS = {
    'inp' => lambda do |vars, var, val|
      vars[var] = val
      vars
    end,
    'add' => lambda do |vars, var, val|
      vars[var] = vars[var] + (val.is_a?(String) ? vars[val] : val)
      vars
    end,
    'mul' => lambda do |vars, var, val|
      vars[var] = vars[var] * (val.is_a?(String) ? vars[val] : val)
      vars
    end,
    'div' => lambda do |vars, var, val|
      vars[var] = vars[var] / (val.is_a?(String) ? vars[val] : val)
      vars
    end,
    'mod' => lambda do |vars, var, val|
      vars[var] = vars[var] % (val.is_a?(String) ? vars[val] : val)
      vars
    end,
    'eql' => lambda do |vars, var, val|
      vars[var] = ((vars[var] == (val.is_a?(String) ? vars[val] : val)) ? 1 : 0)
      vars
    end
  }.freeze

  attr_accessor(:vars)

  def initialize(inputs, commands)
    @commands = commands
    @inputs = inputs
    @vars = {
      'w' => 0,
      'x' => 0,
      'y' => 0,
      'z' => 0
    }
  end

  def process
    @commands.each do |command|
      cmd, var, val = command.split
      val = @inputs.shift if val.nil?
      val = val.to_i unless val.to_i.zero?
      @vars = COMMANDS[cmd].call(@vars, var, val)
    end
  end
end

Instrument.time do
  commands = []
  inputs = [2, 6]
  FileReader.for_each_in('./sample') do |line|
    commands << line.gsub("\n", '')
  end

  #alu = ALU.new(inputs, commands)

  #alu.process

  #puts alu.vars['z'] 

  def prog(z, w, idx)
    as = [1, 1, 1, 26, 1, 26, 26, 1, 26, 1, 1, 26, 26, 26]
    bs = [11, 11, 15, -14, 10, 0, -6, 13, -3, 13, 15, -2, -9, -2]
    cs = [6, 14, 13, 1, 6, 13, 6, 3, 8, 14, 4, 7, 15, 1]

    x = (z % 26) + bs[idx]
    x = x == w ? 1 : 0
    x = x == 0 ? 1 : 0
    z = (z / as[idx]) * ((25 * x) + 1)
    y = (w + cs[idx]) * x
    z = z + y
    z
  end

  def calculate(zt, idx, path)
    if idx == -1
      puts path
      return
    end

    (0..10000).each do |z|
      (1..9).each do |w|
        zo = prog(z, w, idx)
        if zo == zt
          path = "#{w}#{path}"
          calculate(z, idx - 1, path)
        end
      end
    end
  end

  calculate(0, 13, "")
end
