# frozen_string_literal: true

require 'byebug'

def part1
  predictions = []

  File.readlines('data.txt').each do |line|
    readings = line.chomp.split(' ').map(&:to_i)

    last_reads = [readings.last]

    current = readings

    loop do
      break if current.all?(&:zero?)

      buffer = []

      current.each_with_index do |read, index|
        break if index + 1 >= current.length

        buffer << current[index + 1] - read
      end

      last_reads.unshift(buffer.last)

      current = buffer
    end

    new_value = last_reads.first
    last_reads.each_with_index do |_, index|
      break if index + 1 >= last_reads.length

      new_value += last_reads[index + 1]
    end

    predictions << new_value
  end

  puts "Part 1: #{predictions.sum}"
end

def part2
  predictions = []

  File.readlines('data.txt').each do |line|
    readings = line.chomp.split(' ').map(&:to_i)

    first_reads = [readings.first]

    current = readings

    loop do
      break if current.all?(&:zero?)

      buffer = []

      current.each_with_index do |read, index|
        break if index + 1 >= current.length

        buffer << current[index + 1] - read
      end

      first_reads.unshift(buffer.first)

      current = buffer
    end

    new_value = first_reads.first
    first_reads.each_with_index do |_, index|
      break if index + 1 >= first_reads.length

      new_value = first_reads[index + 1] - new_value
    end

    predictions << new_value
  end

  puts "Part 2: #{predictions.sum}"
end

part1
part2
