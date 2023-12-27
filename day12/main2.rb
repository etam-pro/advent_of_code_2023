# frozen_string_literal: true

require 'debug'

def parse(filename)
  input = []
  File.readlines(filename).map(&:chomp).each do |line|
    field, groups = line.split(' ')

    groups = groups.split(',').map(&:to_i)

    input << [field, groups]
  end
  input
end

def possible_fits(field, count, groups, index, acc, prev = '')
  cur = field[0]
  target = groups[index] || 0

  return acc if count > 0 && !target
  return acc if target && count > target

  if cur.nil?
    if count == target
      return acc unless groups[index + 1].nil?

      return acc + 1
    end

    return acc
  end

  case cur
  when '#'
    # keep going
    acc + possible_fits(field[1..-1], count + 1, groups, index, acc, prev + cur)
  when '.'
    # has gear before, but group ended prematurely
    return acc if count > 0 && count < target

    # not yet seeing another gear, keep going with the same setting
    return acc + possible_fits(field[1..-1], count, groups, index, acc, prev + cur) if count == 0

    # found a settting for the current group, going to the next group
    acc + possible_fits(field[1..-1], 0, groups, index + 1, acc, prev + cur)
  when '?'
    # split
    acc + possible_fits('#' + field[1..-1], count, groups, index,
      acc, prev) + possible_fits('.' + field[1..-1], count, groups, index, acc, prev)
  end
end

def part1
  input = parse('day12/data.txt')

  total = 0

  input.each_with_index do |(field, groups), _i|
    count = possible_fits(field, 0, groups, 0, 0)

    total += count
  end

  puts total
end

part1
