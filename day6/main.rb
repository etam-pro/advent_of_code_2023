# frozen_string_literal: true

require 'byebug'

def part1
  times = []
  seconds = []

  str = File.read('data.txt')

  time_raw, dist_raw = str.split("\n")

  times = time_raw.split(':').last.strip.split(' ').map(&:strip).map(&:to_i)
  dists = dist_raw.split(':').last.strip.split(' ').map(&:strip).map(&:to_i)

  total_ways_to_win = []

  times.each_with_index do |time, index|
    ways_to_win = 0

    (0..time).each do |i|
      dist = (time - i) * i
      ways_to_win += 1 if dist > dists[index]
    end

    total_ways_to_win << ways_to_win
  end

  puts "Part 1: #{total_ways_to_win.reduce(&:*)}"
end

def part2
  str = File.read('data.txt')

  time_raw, dist_raw = str.split("\n")

  time = time_raw.split(':').last.split(' ').compact.join('').to_i
  dist = dist_raw.split(':').last.split(' ').compact.join('').to_i

  ways_to_win = 0

  (0..time).each do |i|
    _dist = (time - i) * i
    ways_to_win += 1 if _dist > dist
  end

  puts "Part 2: #{ways_to_win}"
end

part1
part2
