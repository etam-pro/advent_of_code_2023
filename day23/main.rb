# frozen_string_literal: true

require 'debug'

def parse(filename)
  grid = []
  File.readlines(filename).map(&:chomp).each do |line|
    grid << line.split('')
  end
  grid
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

def get_neighbors(grid, current, visited)
  x, y = current

  possible = case grid[y][x]
             when '<'
               [[x - 1, y]]
             when '^'
               [[x, y - 1]]
             when '>'
               [[x + 1, y]]
             when 'v'
               [[x, y + 1]]
             else
               [
                 [x + 1, y],
                 [x - 1, y],
                 [x, y + 1],
                 [x, y - 1]
               ]
             end

  possible.select do |new_x, new_y|
    grid[new_y] && grid[new_y][new_x] &&
      grid[new_y][new_x] != '#' &&
      !visited.include?([new_x, new_y])
  end
end

def bfs(grid, start, fin)
  queue = []
  queue << [start, []]

  max = 0

  until queue.empty?
    cur, visited = queue.shift

    next if visited.include?(cur)

    if cur == fin
      max = visited.size if visited.size > max
      print "#{max}\r"
      next
    end

    nghbs = get_neighbors(grid, cur, visited)
    nghbs.each do |n|
      queue << [n, visited.dup + [cur]]
    end
  end

  max
end

grid = parse('day23/data.txt')
start = get_start(grid)
fin = get_finish(grid)

max = bfs(grid, start, fin, true)

puts max
