# frozen_string_literal: true

require 'byebug'

def get_card_id(line)
  line.split(':').first.split(' ').last.to_i
end

def get_wins(_line)
  win_nums, owned_nums = nums.split('|').map(&:strip)

  win_nums = win_nums.split(' ').map(&:to_i)
  owned_nums = owned_nums.split(' ').map(&:to_i)

  (win_nums & owned_nums).count
end

def part1
  points = []

  File.readlines('data.txt').map(&:chomp).each do |line|
    wins = get_wins(line)
    point = wins > 0 ? 2**(wins - 1) : 0
    points << point
  end

  puts "Part 1: #{points.sum}"
end

def part2
  cards = {}

  File.readlines('data.txt').map(&:chomp).each do |line|
    card_id = get_card_id(line)
    wins = get_wins(line)

    cards[card_id] ||= 0
    cards[card_id] += 1 # for the original card

    next if wins == 0

    (1..wins).each do |i|
      cards[card_id + i] ||= 0
      cards[card_id + i] += 1 * cards[card_id]
    end
  end

  puts "Part 2: #{cards.values.sum}"
end

part1
part2
