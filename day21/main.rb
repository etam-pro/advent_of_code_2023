# frozen_string_literal: true

def parse(filename)
  grid = []

  File.open(filename).readlines.map(&:chomp).each_with_index do |line, y|
    line.split('').map.with_index do |val, x|
      grid[y] ||= []
      grid[y][x] = val
    end
  end

  grid
end

def bfs(grid, start, max_steps)
  steps = {}
  x, y = start

  steps[y] ||= {}
  steps[y][x] = 1

  queue = []
  queue << start

  visited = {}

  cur_steps = 1

  processed = 0

  until queue.empty?
    node = queue.shift
    x, y = node
    next if visited[y] && visited[y][x]

    visited[y] ||= {}
    visited[y][x] = true

    processed += 1
    print "Processed: #{processed}\r"

    next if steps[y][x] > max_steps

    neighbors = get_neighbors(grid, node, visited)
    neighbors.each do |neighbor|
      new_x, new_y = neighbor
      steps[new_y] ||= {}
      steps[new_y][new_x] = steps[y][x] + 1
      queue << neighbor

      steps[new_y][new_x].odd? && grid[new_y][new_x] = 'O'

      cur_steps = steps[new_y][new_x] if steps[new_y][new_x] > cur_steps
    end

    print "Steps: #{cur_steps}\r"
  end

  print_grid(grid)
end

def get_neighbors(grid, node, visited)
  neighbors = []
  x, y = node

  [
    [y - 1, x],
    [y + 1, x],
    [y, x - 1],
    [y, x + 1]
  ].each do |(new_y, new_x)|
    next if new_y.negative? || new_y >= grid.size || new_x.negative? || new_x >= grid.size
    next if grid[new_y][new_x] == '#'
    next if visited.dig(new_y, new_x)

    neighbors << [new_x, new_y]
  end

  neighbors
end

def get_start(grid)
  grid.each_with_index do |row, y|
    row.each_with_index do |val, x|
      return [x, y] if val == 'S'
    end
  end
end

def print_grid(grid)
  grid.each do |row|
    puts row.join('')
  end
end

def part1
  input = parse('day21/data.txt')

  start = get_start(input)

  bfs(input, start, 64)

  puts input.flatten.select { |n| n == 'O' }.size + 1
end

part1
