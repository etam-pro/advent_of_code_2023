# frozen_string_literal: true

require 'debug'

def parse(filename)
  grid = []
  File.readlines(filename).map(&:chomp).each do |line|
    grid << line.split('')
  end
  grid
end

def link(grid, start, next_node, fin, visited = [], graph = {})
  prev = start
  cur = next_node

  steps = 0

  next_nodes = nil

  loop do
    visited << cur
    steps += 1

    x, y = cur

    if cur == fin
      graph[[start, cur]] = steps
      return graph
    end
    return graph if cur.nil?

    possible = [
      [x + 1, y],
      [x - 1, y],
      [x, y + 1],
      [x, y - 1]
    ].select do |new_x, new_y|
      grid[new_y] && grid[new_y][new_x] &&
        grid[new_y][new_x] != '#' &&
        [new_x, new_y] != prev
    end

    if possible.size > 1
      return graph if graph[[start, cur]]

      graph[[start, cur]] = steps
      next_nodes = possible

      break
    end

    prev = cur
    cur = possible.first
  end

  next_nodes.each do |n|
    link(grid, cur, n, fin, visited, graph)
  end

  graph
end

def get_start(grid)
  grid.first.each_with_index do |c, i|
    return [i, 0] if c == '.'
  end
end

def get_finish(grid)
  grid.last.each_with_index do |c, i|
    return [i, grid.size - 1] if c == '.'
  end
end

def bfs(graph, start, fin)
  queue = []
  queue << [start, []]

  max = 0

  until queue.empty?
    cur, visited = queue.shift

    next if visited.include?(cur)

    if cur == fin
      dist = 0

      visited << cur

      visited.each_cons(2) do |a, b|
        dist += graph[[a, b]]
      end
      max = dist if dist > max
      print "#{max}\r"

      next
    end

    nghbs = graph.keys.select { |n| n.first == cur && !visited.include?(n.last) }
    nghbs.each do |n|
      new_visited = visited.dup
      new_visited << cur
      queue << [n.last, new_visited]
    end
  end

  max
end

grid = parse('day23/data.txt')
start = get_start(grid)
fin = get_finish(grid)
x, y = start
next_node = [x, y + 1]
graph = link(grid, start, next_node, fin, [start], {})
max = bfs(graph, start, fin)

puts max
