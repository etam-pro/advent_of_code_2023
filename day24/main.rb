# frozen_string_literal: true

require 'active_support/all'

require 'debug'
require 'z3'

def parse(filename)
  hails = []

  File.readlines(filename).map(&:chomp).each do |line|
    pos, velocity = line.split('@')
    hails << [pos.split(',').map(&:strip).map(&:to_i), velocity.split(',').map(&:strip).map(&:to_i)]
  end

  hails
end

def find_intersection(hail1, hail2)
  x1, y1, z1 = hail1.first
  dx1, dy1, dz1 = hail1.last
  x2, y2, = hail2.first
  dx2, dy2, = hail2.last

  cross_product = dx1 * dy2 - dx2 * dy1

  # parallel
  return nil if cross_product.zero?

  t1 = ((x2 - x1) * dy2 - (y2 - y1) * dx2) / cross_product.to_f
  t2 = ((x2 - x1) * dy1 - (y2 - y1) * dx1) / cross_product.to_f

  [[x1 + dx1 * t1, y1 + dy1 * t1, z1 + dz1 * t1], t1, t2]
end

def part1
  min = 200_000_000_000_000
  max = 400_000_000_000_000

  hails = parse('day24/data.txt')

  total = []

  hails.combination(2).each do |hail1, hail2|
    inter, t1, t2 = find_intersection(hail1, hail2)

    next if inter.nil?

    x, y = inter

    next if x < min || x > max || y < min || y > max
    next unless t1.positive? && t2.positive?

    total << [hail1, hail2]
  end

  puts(total.size)
end

def part2
  hails = parse('day24/data.txt')

  solver = Z3::Solver.new

  x = Z3.Real('x')
  y = Z3.Real('y')
  z = Z3.Real('z')
  dx = Z3.Real('dx')
  dy = Z3.Real('dy')
  dz = Z3.Real('dz')

  hails.each_with_index do |hail, i|
    x2, y2, z2 = hail.first
    dx2, dy2, dz2 = hail.last

    t = Z3.Real("t#{i}")

    solver.assert(x + t * dx == x2 + t * dx2)
    solver.assert(y + t * dy == y2 + t * dy2)
    solver.assert(z + t * dz == z2 + t * dz2)
  end

  if solver.satisfiable?
    total = 0
    xyz = solver.model.each do |n, v|
      %w[x y z].include?(n.to_s) && total += v.to_s.to_i
    end
    puts total
  else
    puts "* Can't solve the problem"
  end
end

part1
part2
