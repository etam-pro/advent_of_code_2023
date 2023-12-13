# frozen_string_literal: true

require 'byebug'

def parse_patterns(filename)
  patterns = []

  cur = []
  File.readlines(filename).each do |line|
    if line == "\n"
      patterns << cur
      cur = []
      next
    end

    cur << line.chomp
  end

  patterns << cur
end

def reflect_vertically?(pattern, loc)
  expand = 0
  loop do
    break if loc + expand + 1 >= pattern.first.size || (loc - expand).negative?

    pattern.each do |row|
      return false if row[loc - expand] != row[loc + expand + 1]
    end

    expand += 1
  end

  true
end

def reflect_horizontally?(pattern, loc)
  expand = 0
  loop do
    break if loc + expand + 1 >= pattern.size || (loc - expand).negative?

    return false if pattern[loc - expand] != pattern[loc + expand + 1]

    expand += 1
  end

  true
end

def find_vertical_reflection(pattern)
  xs = (0..pattern.first.size - 1).select do |loc|
    pattern.all? do |row|
      row[loc + 1] && row[loc] == row[loc + 1]
    end
  end

  return nil unless xs.any?

  xs.each do |loc|
    return loc if reflect_vertically?(pattern, loc)
  end

  nil
end

def find_horizontal_reflection(pattern)
  ys = (0..pattern.size - 1).select do |loc|
    pattern[loc + 1] && pattern[loc] == pattern[loc + 1]
  end

  return nil unless ys.any?

  ys.each do |loc|
    return loc if reflect_horizontally?(pattern, loc)
  end

  nil
end

def find_broken_vertical_reflection(pattern)
  xs = (0..pattern.first.size - 1).select do |x|
    pattern.all? do |row|
      row[x + 1] && row[x] == row[x + 1]
    end
  end

  xs += (0..pattern.first.size).select do |x|
    next if x + 1 >= pattern.first.size

    diff = 0

    pattern.each do |row|
      diff += 1 if row[x] != row[x + 1]
    end

    diff == 1
  end

  return nil unless xs.any?

  x = xs.find do |x|
    expand = 0
    diff = 0
    loop do
      break if x + expand + 1 >= pattern.first.size || x - expand < 0

      pattern.each do |row|
        diff += 1 if row[x - expand] != row[x + expand + 1]
      end

      expand += 1
    end

    diff == 1
  end

  return nil unless x

  expand = 0
  loop do
    break if x + expand + 1 >= pattern.first.size || x - expand < 0

    pattern.each do |row|
      if row[x - expand] != row[x + expand + 1]
        row[x - expand] = row[x + expand + 1]
        break
      end
    end

    expand += 1
  end

  x
end

def find_broken_horizontal_reflection(pattern)
  ys = (0..pattern.size - 1).select do |y|
    pattern[y + 1] && pattern[y] == pattern[y + 1]
  end

  ys += (0..pattern.size - 1).select do |y|
    next if y + 1 >= pattern.size

    diff = 0

    (0..pattern.first.size - 1).each do |x|
      diff += 1 if pattern[y][x] != pattern[y + 1][x]
    end

    diff == 1
  end

  return nil unless ys.any?

  y = ys.find do |y|
    reflect = true
    expand = 0

    diff = 0

    loop do
      break if y + expand + 1 >= pattern.size || y - expand < 0

      diff += 1 if pattern[y - expand] != pattern[y + expand + 1]

      expand += 1
    end

    diff == 1
  end

  return nil unless y

  expand = 0
  loop do
    break if y + expand + 1 >= pattern.size || y - expand < 0

    if pattern[y - expand] != pattern[y + expand + 1]
      pattern[y - expand] = pattern[y + expand + 1]
      break
    end

    expand += 1
  end

  y
end

def part1
  total = []

  patterns = parse_patterns('data.txt')

  patterns.each_with_index do |pattern, _x|
    ver_reflect = find_vertical_reflection(pattern)
    hor_reflect = find_horizontal_reflection(pattern)

    total << ver_reflect + 1 if ver_reflect
    total << (hor_reflect + 1) * 100 if hor_reflect
  end

  puts "Part 1: #{total.sum}"
end

def part2
  total = []

  patterns = parse_patterns('data.txt')

  patterns.each_with_index do |pattern, _x|
    ver_broken_reflect = find_broken_vertical_reflection(pattern)
    hor_broken_reflect = find_broken_horizontal_reflection(pattern)

    ver_reflect = find_vertical_reflection(pattern)
    hor_reflect = find_horizontal_reflection(pattern)

    if ver_broken_reflect
      total << ver_broken_reflect + 1
    elsif hor_broken_reflect
      total << (hor_broken_reflect + 1) * 100
    elsif ver_reflect
      total << ver_reflect + 1
    elsif hor_reflect
      total << (hor_reflect + 1) * 100
    end
  end

  puts "Part 2: #{total.sum}"
end

part1
part2
