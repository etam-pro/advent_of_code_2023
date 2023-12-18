# frozen_string_literal: true

require 'debug'

def parse(filename)
  input = []

  File.readlines(filename).map(&:chomp).each do |line|
    input << line.split(' ')
  end

  input
end

def part1
  input = parse('day18/data.txt')

  cur = [0, 0]
  xys = [cur]

  input.each do |dir, unit, _|
    next_xy = cur.dup

    case dir
    when 'R'
      next_xy[0] += unit.to_i
    when 'L'
      next_xy[0] -= unit.to_i
    when 'U'
      next_xy[1] -= unit.to_i
    when 'D'
      next_xy[1] += unit.to_i
    end

    xys << next_xy
    cur = next_xy
  end

  area_sum = 0

  n = xys.size - 1

  (0..n - 1).each do |i|
    area_sum += xys[i][0] * xys[i + 1][1] - xys[i + 1][0] * xys[i][1]
  end

  area = (area_sum.abs / 2)
  num_edges = input.map { |_, unit, _| unit.to_i }.sum
  i = area - (num_edges / 2) + 1

  puts i + num_edges
end

def get_dir(code)
  case code
  when '0'
    'R'
  when '1'
    'D'
  when '2'
    'L'
  when '3'
    'U'
  end
end

def part2
  input = parse('day18/data.txt')

  cur = [0, 0]
  xys = [cur]

  num_edges = 0

  input.each do |_, _, hex|
    hex = hex.sub('(', '').sub(')', '').sub('#', '')

    unit = hex[0..4].to_i(16)
    dir = get_dir(hex.chars.last)

    next_xy = cur.dup

    case dir
    when 'R'
      next_xy[0] += unit.to_i
    when 'L'
      next_xy[0] -= unit.to_i
    when 'U'
      next_xy[1] -= unit.to_i
    when 'D'
      next_xy[1] += unit.to_i
    end

    xys << next_xy
    num_edges += unit.to_i
    cur = next_xy
  end

  area_sum = 0

  n = xys.size - 1

  (0..n - 1).each do |i|
    area_sum += xys[i][0] * xys[i + 1][1] - xys[i + 1][0] * xys[i][1]
  end

  area = (area_sum.abs / 2)
  i = area - (num_edges / 2) + 1

  puts i + num_edges
end

part1
part2
