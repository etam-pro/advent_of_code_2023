# frozen_string_literal: true

require 'byebug'

def find_qs(row)
  row.chars.each_with_index.map { |char, index| index if char == '?' }.compact
end

def get_groups(row)
  row.gsub('?', '.').split('.').map(&:length).reject(&:zero?)
end

def possible_fits(row, expect, qs, total, covered)
  return 1 if get_groups(row) == expect

  return total if row.count('#') >= expect.sum

  qs.each do |index|
    next if index % 5 == 0

    new_row = row.dup

    5.times { |i| new_row[index + i] = '#' }

    next if covered[new_row]

    covered[new_row] = true

    groups = get_groups(new_row)

    if groups == expect
      total += 1
      next
    end

    new_qs = qs.dup
    new_qs.delete_at(new_qs.index(index))

    total = possible_fits(new_row, expect, new_qs, total, covered)
  end

  total
end

def part1
  total = 0
  File.readlines('data.txt').map(&:chomp).each_with_index do |line, x|
    print "processing: #{x}\r"
    row, groups = line.split(' ')

    expected = groups.split(',').map(&:to_i)
    missing = expected.sum - row.count('#')

    qs = find_qs(row)
    qs.combination(missing).each do |combo|
      new_row = row.dup
      combo.each do |index|
        new_row[index] = '#'
      end

      group = get_groups(new_row)
      total += 1 if group == expected
    end
  end

  puts "\n"
  puts "Part 1: #{total}"
end

def part2
  total = 0
  File.readlines('sample.txt').map(&:chomp).each_with_index do |line, x|
    print "processing: #{x}\r"
    row, groups = line.split(' ')

    row *= 5

    groups = [groups, groups, groups, groups, groups].join(',')

    expected = groups.split(',').map(&:to_i)

    missing = expected.sum - row.count('#')

    qs = find_qs(row)
    qs.combination(missing).each do |combo|
      new_row = row.dup
      combo.each do |index|
        new_row[index] = '#'
      end

      group = get_groups(new_row)
      total += 1 if group == expected
    end
  end

  puts "\n"
  puts "Part 2: #{total}"
end

# part1
part2
