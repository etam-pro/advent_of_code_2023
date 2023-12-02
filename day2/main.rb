# frozen_string_literal: true

require 'byebug'

CUBES = {
  'red' => 12,
  'green'=> 13,
  'blue' => 14
}

def part_1
  ids = []


  File.readlines('data.txt').each do |line|
    valid = true

    id = line.chomp.split(':').first.split(' ').last.to_i
    
    shows = line.chomp.split(':').last.split(';').map(&:strip)

    shows.each do |show|
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

  puts "Part 1: #{ids.sum}"
end

def part_2
  powers = []

  File.readlines('data.txt').each do |line|
    shows = line.chomp.split(':').last.split(';').map(&:strip)

    cubes = {}

    shows.each do |show|


      show.split(',').each do |shown|
        val, color = shown.split(' ')
        
        if cubes[color].nil? || cubes[color] < val.to_i
          cubes[color] = val.to_i
        end
      end
    end

    powers << cubes.values.reduce(:*)
  end

  puts "Part 2: #{powers.sum}"
end

part_1
part_2
