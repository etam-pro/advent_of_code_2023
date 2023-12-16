# frozen_string_literal: true

require 'debug'

class Node
  attr_accessor :value, :x, :y, :energized

  def initialize(value, x, y, energized: false)
    @value = value
    @x = x
    @y = y
    @energized = []
  end

  def parallel?(dir)
    x_dir, y_dir = dir

    return true if value == '.'
    return true if x_dir.abs == 1 && y_dir.abs == 0 && value == '-'
    return true if x_dir.abs == 0 && y_dir.abs == 1 && value == '|'

    false
  end

  def split?(dir)
    x_dir, y_dir = dir

    return true if x_dir.abs == 1 && y_dir.abs == 0 && value == '|'
    return true if x_dir.abs == 0 && y_dir.abs == 1 && value == '-'

    false
  end

  def reflect?
    ['/', '\\'].include?(value)
  end

  def dead_end?(dir, nodes)
    x_dir, y_dir = dir

    return true if y + y_dir < 0
    return true if y + y_dir >= nodes.length
    return true if x + x_dir < 0
    return true if x + x_dir >= nodes[y + y_dir].length

    false
  end

  def reflect_dir(dir)
    x_dir, y_dir = dir

    return [y_dir * -1, x_dir * -1] if value == '/'

    return unless value == '\\'

    [y_dir, x_dir]
  end

  def next_nodes(nodes, dir)
    next_nodes = []
    x_dir, y_dir = dir

    if parallel?(dir) && !dead_end?(dir, nodes)
      n = nodes[y + y_dir][x + x_dir]
      next_nodes << [[x_dir, y_dir], n]
    end

    new_dirs = []

    if split?(dir)
      new_dirs = [
        [y_dir, x_dir],
        [-y_dir, -x_dir]
      ]
    end

    if reflect?

      new_x_dir = x_dir.abs == 1 ? 0 : y_dir * -1
      new_y_dir = y_dir.abs == 1 ? 0 : x_dir * -1

      new_dirs << reflect_dir(dir)
    end

    new_dirs.each do |new_dir|
      next if dead_end?(new_dir, nodes)

      new_dir_x, new_dir_y = new_dir
      n = nodes[y + new_dir_y][x + new_dir_x]
      next_nodes << [new_dir, n]
    end

    next_nodes
  end
end

def parse(filename)
  nodes = []

  File.readlines(filename).map(&:chomp).each_with_index do |line, y|
    row = []
    line.split('').each_with_index do |char, x|
      row << Node.new(char, x, y)
    end
    nodes << row
  end

  nodes
end

def trace(nodes, start)
  dir, node = start
  node.energized = [dir]
  queue = [start]

  until queue.empty?
    dir, node = queue.shift

    node.next_nodes(nodes, dir).each do |(dir, next_node)|
      next if next_node.energized.include?(dir)

      next_node.energized << dir
      queue << [dir, next_node]
    end
  end
end

def print_energized(nodes)
  nodes.each do |row|
    row.each do |node|
      print node.energized.empty? ? '.' : '#'
    end
    puts
  end
end

def reset(nodes)
  nodes.flatten.each do |node|
    node.energized = []
  end
end

def get_edge_nodes(nodes)
  edge_nodes = []

  edge_nodes += nodes.flatten.select { |n| n.x == 0 }.map { |n| [[1, 0], n] }
  edge_nodes += nodes.flatten.select { |n| n.x == nodes[0].length - 1 }.map { |n| [[-1, 0], n] }
  edge_nodes += nodes.flatten.select { |n| n.y == 0 }.map { |n| [[0, 1], n] }
  edge_nodes += nodes.flatten.select { |n| n.y == nodes.length - 1 }.map { |n| [[0, -1], n] }

  edge_nodes
end

def part1
  nodes = parse('day16/data.txt')
  start = nodes[0][0]
  trace(nodes, [[1, 0], start])
  puts "Part 1: #{nodes.flatten.count { |n| !n.energized.empty? }}"
end

def part2
  nodes = parse('day16/data.txt')
  starts = get_edge_nodes(nodes)

  scores = []
  starts.each do |s|
    reset(nodes)
    trace(nodes, s)
    scores << nodes.flatten.count { |n| !n.energized.empty? }
  end

  puts "Part 2: #{scores.max}"
end

part1
part2
