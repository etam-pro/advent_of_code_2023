# frozen_string_literal: true

require 'debug'

require 'active_support/core_ext/object/deep_dup'

class Node
  attr_accessor :value, :x, :y, :visited, :dist, :prevs

  def initialize(value, x, y)
    @value = value
    @x = x
    @y = y
    @dist = Float::INFINITY
    @prevs = {}
  end

  def xy
    [x, y]
  end
end

class Graph
  attr_accessor :nodes, :min

  DIRS = {
    up: [0, -1],
    down: [0, 1],
    left: [-1, 0],
    right: [1, 0]
  }

  def initialize(nodes, min_dir_in_a_row = 1, max_dir_in_a_row = 3)
    @nodes = nodes
    @min = Float::INFINITY

    @dist = {}
    @prev = {}
    @search = 0

    @min_dir_in_a_row = min_dir_in_a_row
    @max_dir_in_a_row = max_dir_in_a_row
  end

  def start
    @nodes[0][0]
  end

  def finish
    @nodes.last.last
  end

  def max_x
    @nodes.first.size - 1
  end

  def max_y
    @nodes.size - 1
  end

  def out_of_bounds?(cur, dir)
    x_dir, y_dir = dir

    return true if cur.x + x_dir < 0 || cur.y + y_dir < 0
    return true if cur.x + x_dir > max_x || cur.y + y_dir > max_y

    false
  end

  def calc
    start.prevs[[]] = 0
    queue = [[start, []]]

    until queue.empty?
      cur, prevs = queue.shift
      dirs = if cur == start
               [DIRS[:down], DIRS[:right]]
             else
               prev_x, prev_y = prevs.last
               dir = [cur.x - prev_x, cur.y - prev_y]

               if can_turn?(cur, prevs, dir)
                 possible_dirs(dir)
               else
                 [dir]
               end
             end

      puts "#{cur.xy}"

      if cur == finish
        if can_turn?(cur, prevs, dir)
          if cur.prevs[prevs] < @min
            @min = cur.prevs[prevs]
            print  "#{@min} \r"
          end

        else
          cur.prevs.delete(prevs)
        end
        next
      end

      next if cur.prevs[prevs] && cur.prevs[prevs] >= @min

      dirs
        .filter { |new_dir| !out_of_bounds?(cur, new_dir) }
        .filter { |new_dir| can_move?(cur, prevs, new_dir) }
        .each do |new_dir|
          x_dir, y_dir = new_dir

          next_node = @nodes[cur.y + y_dir][cur.x + x_dir]

          alt = next_node.value + cur.prevs[prevs]
          next_prevs = prevs.last(@max_dir_in_a_row - 1) + [cur.xy]

          next if next_node.prevs[next_prevs] && next_node.prevs[next_prevs] <= alt

          next_node.prevs[next_prevs] = alt
          queue << [next_node, next_prevs]
        end
    end

    finish.prevs.values.min
  end

  def possible_dirs(cur_dir)
    dirs = []

    case cur_dir
    when DIRS[:up]
      dirs << DIRS[:left]
      dirs << DIRS[:right]
      dirs << DIRS[:up]
    when DIRS[:down]
      dirs << DIRS[:left]
      dirs << DIRS[:right]
      dirs << DIRS[:down]
    when DIRS[:left]
      dirs << DIRS[:up]
      dirs << DIRS[:down]
      dirs << DIRS[:left]
    when DIRS[:right]
      dirs << DIRS[:up]
      dirs << DIRS[:down]
      dirs << DIRS[:right]
    end

    dirs
  end

  def same_dirs_in_a_row(cur, prevs, dir)
    count = 0
    ns = (prevs + [cur.xy]).reverse
    ns.each_with_index do |n, i|
      break if n.nil?
      break if ns[i + 1].nil?

      cur_x, cur_y = n
      prev_x, prev_y = ns[i + 1]

      cur_dir = [cur_x <=> prev_x, cur_y <=> prev_y]
      break if cur_dir != dir

      count += 1
    end
    count
  end

  def can_move?(cur, prevs, dir)
    count = same_dirs_in_a_row(cur, prevs, dir)

    count < @max_dir_in_a_row
  end

  def can_turn?(cur, prevs, dir)
    count = same_dirs_in_a_row(cur, prevs, dir)

    count >= @min_dir_in_a_row
  end
end

def parse(filename, min, max)
  nodes = []

  File.readlines(filename).map(&:chomp).each_with_index do |line, y|
    nodes << line.split('').map.with_index { |c, x| Node.new(c.to_i, x, y) }
  end

  Graph.new(nodes, min, max)
end

def part1
  graph = parse('day17/sample.txt', 1, 3)
  min = graph.calc

  puts min
end

def part2
  graph = parse('day17/data.txt', 4, 10)
  min = graph.calc

  puts min
end

part1
part2
