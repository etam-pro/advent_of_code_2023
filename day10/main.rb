# frozen_string_literal: true

require 'byebug'

class Node
  attr_accessor :value, :x, :y, :visited, :left, :right, :from, :dist, :loop, :enclosed

  def initialize(value, x, y)
    @value = value
    @x = x
    @y = y
    @visited = false

    @left = nil
    @right = nil
    @from = nil
    @dist = 0
    @loop = false
    @enclosed = false
  end

  def pipe?
    ['|', '-'].include?(@value)
  end

  def corner?
    case @value
    when 'L', 'J', '7', 'F'
      true
    else
      false
    end
  end
end

def parse_map
  ns = []

  File.readlines('data.txt').each_with_index do |line, y|
    row = line.chomp.split('').map.with_index do |char, x|
      Node.new(char, x, y)
    end

    ns << row
  end

  ns.each do |row|
    row.each do |n|
      next if n.value == '.' || n.value == 'S'

      left, right = get_next_nodes(n)

      n.left = ns[left.last][left.first] if left && left.first >= 0 && left.last < ns.size && ns[left.last][left.first]
      if right && right.first >= 0 && right.last < ns.size && ns[right.last][right.first]
        n.right = ns[right.last][right.first]
      end
    end
  end

  link_start(ns)

  ns
end

def get_next_nodes(node)
  xys = []

  case node.value
  when '|'
    xys << [node.x, node.y - 1] if node.y - 1 >= 0
    xys << [node.x, node.y + 1]
  when '-'
    xys << [node.x - 1, node.y] if node.x - 1 >= 0
    xys << [node.x + 1, node.y]
  when 'L'
    xys << [node.x, node.y - 1] if node.y - 1 >= 0
    xys << [node.x + 1, node.y]
  when 'J'
    xys << [node.x, node.y - 1] if node.y - 1 >= 0
    xys << [node.x - 1, node.y] if node.x - 1 >= 0
  when '7'
    xys << [node.x, node.y + 1]
    xys << [node.x - 1, node.y] if node.x - 1 >= 0
  when 'F'
    xys << [node.x, node.y + 1]
    xys << [node.x + 1, node.y]
  else
    raise "Unknown value #{node.value}"
  end

  xys
end

def link_start(nodes)
  next_nodes = nodes
    .flatten
    .select { |n| n.value != '.' && n.value != 'S' }
    .select { |n| n.left&.value == 'S' || n.right&.value == 'S' }

  start = find_start(nodes)
  start.left = next_nodes.first
  start.right = next_nodes.last
end

def find_start(nodes)
  nodes.flatten.find { |n| n.value == 'S' }
end

def detect_loop(start)
  start.loop = true

  start.left.dist += 1
  start.left.from = start

  queue = [start.left]

  until queue.empty?
    node = queue.shift
    node.loop = true

    return true if node == start

    node.visited = true

    if node.left && node.left != node.from
      node.left.from = node
      node.left.dist = node.dist + 1
      queue << node.left
    end

    next unless node.right && node.right != node.from

    node.right.from = node
    node.right.dist = node.dist + 1
    queue << node.right

  end

  false
end

def part1
  ns = parse_map
  start = find_start(ns)
  is_loop = detect_loop(start)

  raise 'Loop not detected' unless is_loop

  puts "Part 1: #{ns.flatten.map(&:dist).max / 2}"
end

def print_map(nodes)
  map_str = nodes.map do |row|
    puts row.map(&:value).join('')
  end.join("\n")
  puts map_str
end

def print_dist(nodes)
  map_str = nodes.map do |row|
    puts row.map(&:dist).join('')
  end.join("\n")
  puts map_str
end

def print_loop(nodes)
  map_str = nodes.map do |row|
    puts row.map { |n| n.loop ? '#' : '.' }.join('')
  end.join("\n")
  puts map_str
end

def print_enclosed(nodes)
  map_str = nodes.map do |row|
    str = row.map do |n|
      if n.loop
        n.value
      elsif n.enclosed
        'I'
      else
        'O'
      end
    end.join('')
    str
  end.join("\n")
  puts map_str
end

def part2
  ns = parse_map
  start = find_start(ns)
  detect_loop(start)

  ns.each_with_index do |row, _y|
    row.each_with_index do |n, x|
      next if n.loop

      row_str = row[0..x - 1]
        .map { |n| n.loop ? n.value : '.' }
        .join('')
        .gsub('-', '')

      pipes = row_str.scan(/\|/).count
      pipes += row_str.scan(/FJ/).count
      pipes += row_str.scan(/L7/).count

      n.enclosed = pipes.odd?
    end
  end

  total = ns.flatten.count { |n| n.enclosed && !n.loop }

  print_enclosed(ns)

  puts "Part 2: #{total}"
end

# part1
part2
