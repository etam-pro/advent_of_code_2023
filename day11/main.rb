# frozen_string_literal: true

require 'byebug'

def part1
  universe = File.readlines('data.txt')
    .map(&:chomp)
    .map(&:chars)

  empty_cols = (0..universe.first.size - 1)
    .to_a
    .select { |x| universe.all? { |row| row[x] == '.' } }

  expanded = []
  universe.each_with_index do |row, _y|
    new_row = []
    row.each_with_index do |char, x|
      new_row << char
      new_row << char if empty_cols.include?(x)
    end
    expanded << new_row
    expanded << new_row if new_row.all? { |x| x == '.' }
  end

  galaxies = []

  expanded.each_with_index do |row, y|
    row.each_with_index do |char, x|
      galaxies << [x, y] if char == '#'
    end
  end

  lens = []
  galaxies.combination(2).to_a.each do |(x1, y1), (x2, y2)|
    dx = (x2 - x1).abs
    dy = (y2 - y1).abs

    lens << (dx + dy)
  end

  puts "Part 1: #{lens.sum}"
end

def part2
  universe = File.readlines('data.txt')
    .map(&:chomp)
    .map(&:chars)

  empty_cols = (0..universe.first.size - 1)
    .to_a
    .select { |x| universe.all? { |row| row[x] == '.' } }

  empty_rows = (0..universe.size - 1)
    .to_a
    .select { |y| universe[y].all? { |x| x == '.' } }

  galaxies = []
  universe.each_with_index do |row, y|
    row.each_with_index do |char, x|
      galaxies << [x, y] if char == '#'
    end
  end

  lens = []
  galaxies.combination(2).to_a.each do |(x1, y1), (x2, y2)|
    dx = (x2 - x1).abs
    dy = (y2 - y1).abs

    len = (dx + dy) + empty_cols.count { |x|
                        ([x1, x2].min..[x1, x2].max).include?(x)
                      } * 999_999 + empty_rows.count { |y|
                                      ([y1, y2].min..[y1, y2].max).include?(y)
                                    } * 999_999

    lens << len
  end

  puts "Part 2: #{lens.sum}"
end

def print_universe(universe)
  universe.each do |row|
    puts row.join('')
  end
end

part1
part2
