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

def possible_fits(field, count, groups, index, acc, memo)
  cur = field[0]
  target = groups[index] || 0

  return memo[[field, count, groups, index]] if memo[[field, count, groups, index]]

  if cur.nil?
    return acc if count != target

    if target && count == target
      return acc unless groups[index + 1].nil?

      return acc + 1
    end

    return acc
  end

  case cur
  when '#'
    # too many gears
    return acc if count > 0 && count == target
    return acc if groups[index].nil?

    # keep going
    combo = acc + possible_fits(field[1..-1], count + 1, groups, index, acc, memo)
    memo[[field, count, groups, index]] = combo
    combo
  when '.'
    # has gear before, but group ended prematurely
    return acc if count > 0 && count < target

    # not yet seeing another gear, keep going with the same setting
    return acc + possible_fits(field[1..-1], count, groups, index, acc, memo) if count == 0

    # found a settting for the current group, going to the next group
    combo = acc + possible_fits(field[1..-1], 0, groups, index + 1, acc, memo)
    memo[[field, count, groups, index]] = combo
    combo

  when '?'
    # split
    combo = acc + possible_fits('#' + field[1..-1], count, groups, index,
      acc, memo) + possible_fits('.' + field[1..-1], count, groups, index, acc, memo)

    memo[[field, count, groups, index]] = combo
    combo
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

def part2
  input = parse('day12/data.txt')

  total = 0
  memo = {}

  input.each_with_index do |(field, groups), _i|
    field = [field, field, field, field, field].join('?')
    groups = groups + groups + groups + groups + groups

    count = possible_fits(field, 0, groups, 0, 0, memo)

    total += count
  end

  puts total
end

part1
part2
