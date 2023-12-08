# frozen_string_literal: true

require 'byebug'

def parse_data
  instructions = nil
  nodes = {}

  File.readlines('sample3.txt').map(&:chomp).map do |line|
    next if line == ''

    unless line.include?('=')
      instructions = line.split('')
      next
    end

    node, left_right = line.split(' = ')

    left, right = left_right.gsub(/[()]/, '').split(',').map(&:strip)

    nodes[node] = { L: left, R: right }
  end

  [instructions, nodes]
end

def part1
  instructions, nodes = parse_data

  steps = 0

  current = 'AAA'

  loop do
    break if current == 'ZZZ'

    instruction = instructions[steps % instructions.length]
    current = nodes[current][instruction.to_sym]

    steps += 1
  end

  puts "Part 1: #{steps}"
end

def part2
  instructions, nodes = parse_data

  starts = nodes.keys.select { |k| k.end_with?('A') }

  steps_by_start = {}

  starts.each do |start|
    current = start
    steps = 0

    loop do
      break if current.end_with?('Z')

      instruction = instructions[steps % instructions.length]
      current = nodes[current][instruction.to_sym]

      steps += 1
    end

    steps_by_start[start] = steps
  end

  steps = steps_by_start.values.reduce(steps_by_start.values.first) do |lcm, val|
    lcm = lcm.lcm(val)
    lcm
  end

  puts "Part 2: #{steps}"
end

part1
part2
