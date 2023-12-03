# frozen_string_literal: true

def part?(engine, x, y)
  # down
  return true if engine[y - 1] && symbol?(engine[y - 1][x])

  # up
  return true if engine[y + 1] && symbol?(engine[y + 1][x])

  # left
  return true if symbol?(engine[y][x - 1])

  # right
  return true if symbol?(engine[y][x + 1])

  # diagonal
  return true if engine[y - 1] && symbol?(engine[y - 1][x - 1])
  return true if engine[y - 1] && symbol?(engine[y - 1][x + 1])
  return true if engine[y + 1] && symbol?(engine[y + 1][x - 1])
  return true if engine[y + 1] && symbol?(engine[y + 1][x + 1])

  # adjuscent is also number
  return part?(engine, x + 1, y) if engine[y][x + 1] =~ /\d/

  false
end

def symbol?(char)
  char =~ /\D/ && char != '.'
end

def find_num(engine, x, y)
  return if x.negative?

  return nil if engine[y][x] =~ /\D/

  start = x
  last = x

  loop do
    break unless engine[y][start - 1] =~ /\d/

    start -= 1
  end

  loop do
    break unless engine[y][last + 1] =~ /\d/

    last += 1
  end

  [engine[y][start..last].join(''), start, last]
end

def part1
  engine = []
  scanned = []
  part_nums = []

  File.readlines('data.txt').map(&:chomp).each_with_index do |line, _index|
    engine << line.split('')
  end

  engine.each_with_index do |line, y|
    line.each_with_index do |char, x|
      next if scanned[y] && x < scanned[y]
      next if char == '.'
      next unless char =~ /\d/
      next unless part?(engine, x, y)

      num, = find_num(engine, x, y)
      part_nums << num
      scanned[y] = x + num.length
    end
  end

  puts "Part 1: #{part_nums.map(&:to_i).sum}"
end

def part2
  engine = []
  covered = []
  gear_ratios = []

  File.readlines('data.txt').map(&:chomp).each_with_index do |line, _index|
    engine << line.split('')
  end

  engine.each_with_index do |line, y|
    line.each_with_index do |char, x|
      next if char != '*'

      gear_ratio = []

      [
        [y - 1, x - 1],
        [y - 1, x],
        [y - 1, x + 1],
        [y, x - 1],
        [y, x + 1],
        [y + 1, x - 1],
        [y + 1, x],
        [y + 1, x + 1]
      ].each do |(y, x)|
        next if covered[y] && covered[y][x]

        num, start, last = find_num(engine, x, y)

        next unless num

        gear_ratio << num.to_i
        (start..last).to_a.each do |val|
          covered[y] ||= []
          covered[y][val] = true
        end
      end

      next if gear_ratio.length != 2

      gear_ratios << gear_ratio
    end
  end

  puts "Part 2: #{gear_ratios.map { |gr| gr.first * gr.last }.sum}"
end

part1
part2
