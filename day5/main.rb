# frozen_string_literal: true

require 'active_support/all'
require 'byebug'

MapRange = Struct.new(:dest, :source, :range) do
  def mapped?(num)
    num >= source && num <= source + range
  end

  def revert_mapped?(num)
    num >= dest && num <= dest + range
  end

  def convert(num)
    num - source + dest
  end

  def revert(num)
    num - dest + source
  end
end

def part1
  seeds = []

  maps = {
    seed_to_soil: [],
    soil_to_fertilizer: [],
    fertilizer_to_water: [],
    water_to_light: [],
    light_to_temperature: [],
    temperature_to_humidity: [],
    humidity_to_location: []
  }

  current = :seeds

  File.readlines('data.txt').each do |line|
    if line =~ /seeds:/
      seeds = line.split(':').last.strip.split(' ').map(&:to_i)
      next
    end

    next if line == "\n"

    if line =~ /map/
      current = line.split(' ').first.underscore.to_sym
      next
    end

    dest, source, range = line.strip.split(' ').map(&:to_i)
    maps[current] << MapRange.new(dest, source, range)
  end

  loc_nums = seeds.map do |seed|
    loc_num = seed

    maps.values.each do |m|
      m.each do |range|
        if range.mapped?(loc_num)
          loc_num = range.convert(loc_num)
          break
        end
      end
    end

    loc_num
  end

  puts loc_nums.min
end

def part2
  seeds = []

  maps = {
    seed_to_soil: [],
    soil_to_fertilizer: [],
    fertilizer_to_water: [],
    water_to_light: [],
    light_to_temperature: [],
    temperature_to_humidity: [],
    humidity_to_location: []
  }

  current = :seeds

  File.readlines('data.txt').each do |line|
    if line =~ /seeds:/
      seed_nums, seed_range_sizes = line.split(':')
                                        .last
                                        .strip
                                        .split(' ')
                                        .map(&:to_i)
                                        .partition.with_index { |_, i| i.even? }

      seed_nums.each_with_index do |seed_num, i|
        seeds << (seed_num..(seed_num + seed_range_sizes[i] - 1))
      end

      seeds.flatten!
      next
    end

    next if line == "\n"

    if line =~ /map/
      current = line.split(' ').first.underscore.to_sym
      next
    end

    dest, source, range = line.strip.split(' ').map(&:to_i)
    maps[current] << MapRange.new(dest, source, range)
  end

  loc_num = 0

  while true
    print "#{loc_num}\r"

    seed = loc_num

    maps.values.reverse.each do |m|
      m.each do |range|
        if range.revert_mapped?(seed)
          seed = range.revert(seed)
          break
        end
      end
    end

    if seeds.any? { |sr| sr.include?(seed) }
      puts "Part 2: #{loc_num}"
      break
    end

    loc_num += 1
  end
end

part1
part2
