# frozen_string_literal: true

require 'byebug'

def parse(filename)
  File.read(filename).chomp.split(',')
end

def hashie(str)
  val = 0

  str.chars.each do |c|
    val += c.ord
    val *= 17
    val %= 256
  end

  val
end

def get_label(str, op)
  str.split(op).first
end

def part1
  inputs = parse('data.txt')

  vals = inputs.map do |str|
    hashie(str)
  end

  puts vals.sum
end

def part2
  inputs = parse('data.txt')

  boxes = {}

  inputs.each do |str|
    operation = str.include?('=') ? '=' : '-'

    label = get_label(str, operation)
    box = hashie(label)
    boxes[box] ||= []

    lens = boxes[box].find { |l| get_label(l, '=') == label }

    if operation == '='
      if lens
        slot = boxes[box].index(lens)
        boxes[box][slot] = str
      else
        boxes[box] << str
      end
    elsif lens
      boxes[box].delete(lens)
    end
  end

  powers = boxes.map do |box, lenses|
    power = 0

    lenses.each_with_index do |lens, i|
      power += lens.split('=').last.to_i * (i + 1) * (box + 1)
    end

    power
  end

  puts powers.sum
end

part1
part2
