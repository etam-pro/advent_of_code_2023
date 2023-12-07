# frozen_string_literal: true

require 'byebug'

CARDS = %w[2 3 4 5 6 7 8 9 T J Q K A].freeze
CARDS_WITH_JOKER = %w[J 2 3 4 5 6 7 8 9 T J Q K A].freeze

RANKS = %i[high_card one_pair two_pairs three_of_a_kind straight flush full_house four_of_a_kind
           straight_flush five_of_a_kind].freeze

def kind(hand)
  cards = hand.split('')

  return :five_of_a_kind if cards.uniq.count == 1

  if cards.uniq.count == 2
    return :four_of_a_kind if cards.any? { |c| cards.count(c) == 4 }

    return :full_house
  end

  if cards.uniq.count == 3
    return :three_of_a_kind if cards.any? { |c| cards.count(c) == 3 }

    return :two_pairs
  end

  return :one_pair if cards.uniq.count == 4

  :high_card
end

def kind_with_joker(hand)
  cards = hand.split('')
  jokers = cards.count('J')
  normal_cards = cards.filter { |c| c != 'J' }
  uniq_cards = [normal_cards.uniq.count, 1].max # 1 is for the case of 5 jokers

  return :five_of_a_kind if uniq_cards == 1

  if uniq_cards == 2
    return :four_of_a_kind if normal_cards.any? { |c| normal_cards.count(c) == 4 - jokers }

    return :full_house
  end

  if uniq_cards == 3
    return :three_of_a_kind if normal_cards.any? { |c| normal_cards.count(c) == 3 - jokers }

    return :two_pairs
  end

  return :one_pair if uniq_cards == 4

  :high_card
end

def compare(a, b)
  return 1 if RANKS.index(kind(a)) > RANKS.index(kind(b))
  return -1 if RANKS.index(kind(a)) < RANKS.index(kind(b))

  cards_a = a.split('')
  cards_b = b.split('')

  cards_a.each_with_index do |card, index|
    return 1 if CARDS.index(card) > CARDS.index(cards_b[index])
    return -1 if CARDS.index(card) < CARDS.index(cards_b[index])
  end

  0
end

def compare_with_joker(a, b)
  return 1 if RANKS.index(kind_with_joker(a)) > RANKS.index(kind_with_joker(b))
  return -1 if RANKS.index(kind_with_joker(a)) < RANKS.index(kind_with_joker(b))

  cards_a = a.split('')
  cards_b = b.split('')

  cards_a.each_with_index do |card, index|
    return 1 if CARDS_WITH_JOKER.index(card) > CARDS_WITH_JOKER.index(cards_b[index])
    return -1 if CARDS_WITH_JOKER.index(card) < CARDS_WITH_JOKER.index(cards_b[index])
  end

  0
end

def part1
  hands = []

  File.readlines('data.txt').each do |line|
    hands << line.chomp.split(' ')
  end

  hands = hands.sort do |a, b|
    compare(a.first, b.first)
  end

  total_winning = 0
  hands.each_with_index do |(_, bid), index|
    total_winning += bid.to_i * (index + 1)
  end

  puts "Part 1: #{total_winning}"
end

def part2
  hands = []

  File.readlines('data.txt').each do |line|
    hands << line.chomp.split(' ')
  end

  hands = hands.sort do |a, b|
    compare_with_joker(a.first, b.first)
  end

  total_winning = 0
  hands.each_with_index do |(_, bid), index|
    total_winning += bid.to_i * (index + 1)
  end

  puts "Part 2: #{total_winning}"
end

part1
part2
