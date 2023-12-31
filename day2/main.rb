# frozen_string_literal: true

CUBES = {
  'red' => 12,
  'green' => 13,
  'blue' => 14
}.freeze

def part1
  ids = []

  File.readlines('data.txt').each do |line|
    valid = true

    id = line.chomp.split(':').first.split(' ').last.to_i

    line
      .chomp
      .split(':')
      .last
      .split(';')
      .map(&:strip)
      .each do |show|
      show.split(',').each do |cubes|
        val, color = cubes.split(' ')
        if CUBES[color] < val.to_i
          valid = false
          break
        end
      end
    end

    ids << id if valid
  end

  puts("Part 1: #{ids.sum}")
end

def part2
  powers = []

  File.readlines('data.txt').each do |line|
    cubes = {}

    line
      .chomp
      .split(':')
      .last
      .split(';')
      .map(&:strip)
      .each do |show|
        show.split(',').each do |shown|
          val, color = shown.split(' ')

          next if cubes[color] && cubes[color] >= val.to_i

          cubes[color] = val.to_i
        end
      end

    powers << cubes.values.reduce(:*)
  end

  puts("Part 2: #{powers.sum}")
end

part1
part2
