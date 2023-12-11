# frozen_string_literal: true

LETTERS_MAP = {
  'one' => '1',
  'two' => '2',
  'three' => '3',
  'four' => '4',
  'five' => '5',
  'six' => '6',
  'seven' => '7',
  'eight' => '8',
  'nine' => '9',
  'ten' => '10',
  'eleven' => '11',
  'twelve' => '12',
  'thirteen' => '13',
  'fourteen' => '14',
  'fifteen' => '15',
  'sixteen' => '16',
  'seventeen' => '17',
  'eighteen' => '18',
  'nineteen' => '19',
  'twenty' => '20'
}

def detect_first_digit(str, letters_map = {})
  str.split('').each_with_index do |char, i|
    return char if char.match?(/\d/)

    letters_map.each do |word, digit|
      return digit.split('').last if str[i..i + word.length - 1] == word
    end
  end
end

def part_1
  vals = []

  File.readlines('data.txt').each do |line|
    digits = line.chomp
    first_digit = detect_first_digit(digits)
    last_digit = detect_first_digit(digits.reverse)

    vals << first_digit.to_i * 10 + last_digit.to_i
  end

  puts "Part 1: #{vals.sum}"
end

def part_2
  vals = []

  File.readlines('data.txt').each do |line|
    digits = line.chomp
    first_digit = detect_first_digit(digits, LETTERS_MAP)
    last_digit = detect_first_digit(digits.reverse, LETTERS_MAP.transform_keys(&:reverse))

    vals << first_digit.to_i * 10 + last_digit.to_i
  end

  puts "Part 2: #{vals.sum}"
end

part_1
part_2
