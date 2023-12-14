# frozen_string_literal: true

require 'byebug'

require 'active_support/all'

def parse(filename)
  platform = []

  File.readlines(filename).each do |line|
    platform << line.chomp.split('')
  end

  platform
end

def slide(platform)
  platform.each_with_index do |row, y|
    row.each_with_index do |col, x|
      next if ['.', '#'].include?(col)

      new_pos = y

      loop do
        break if (new_pos - 1).negative?

        platform[new_pos - 1][x] != '.' && break

        new_pos -= 1
      end

      platform[y][x] = '.'
      platform[new_pos][x] = col
    end
  end
end

def rotate(platform)
  new_platform = []

  platform.each_with_index do |row, y|
    row.each_with_index do |col, x|
      new_platform[x] ||= []
      new_platform[x][platform.size - y - 1] = col
    end
  end

  new_platform
end

def calc_load(platform)
  load = []

  platform.each_with_index do |row, y|
    row.each_with_index do |col, _x|
      next if ['.', '#'].include?(col)

      load << platform.size - y
    end
  end

  load.sum
end

def part1
  platform = parse('data.txt')
  slide(platform)
  puts calc_load(platform)
end

def part2
  platform = parse('data.txt')

  tried = []

  cycle_length = 0
  offset = 0

  i = 0

  loop do
    4.times do
      slide(platform)
      platform = rotate(platform)
    end

    if tried.index(platform)
      cycle_length = i - tried.index(platform)
      offset = tried.index(platform) - 1
      break
    end

    print "i: #{i}\r"

    tried << platform.deep_dup

    i += 1
  end

  remainder = (1_000_000_000 - offset - 1) % cycle_length

  state = tried[offset + remainder].deep_dup

  puts calc_load(state)
end

def print_platform(plat)
  plat.each do |row|
    puts row.join('')
  end

  nil
end

# part1
part2
