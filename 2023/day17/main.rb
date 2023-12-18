###
### Aoc 2023. Day 17
###

require "pqueue"

# takes ~14s
def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n").map { |line| line.chars.map(&:to_i) }
  dijkstra(data, min_steps: 1, max_steps: 3)
end

# takes ~150s
def part_two_answer(file = "input.txt")
  data = File.read(file).split("\n").map { |line| line.chars.map(&:to_i) }
  dijkstra(data, min_steps: 4, max_steps: 10)
end

# ----

DIRECTIONS = {
  up: [-1, 0],
  right: [0, 1],
  down: [1, 0],
  left: [0, -1]
}.freeze

class WalkPath
  attr_reader :cost, :x, :y, :direction, :steps

  def initialize(cost, x, y, direction, steps)
    @cost = cost
    @x = x
    @y = y
    @direction = direction
    @steps = steps
  end

  def visited_info
    [x, y, direction, steps]
  end
end

# TODO: here
def dijkstra(graph, min_steps:, max_steps:)
  pq = PQueue.new { |a, b| a.cost < b.cost }
  # init with two possible directions
  pq.push(WalkPath.new(0, 0, 0, DIRECTIONS[:right], 1))
  pq.push(WalkPath.new(0, 0, 0, DIRECTIONS[:down], 1))
  visited = Set.new

  until pq.empty?
    # get elem with min steps
    curr = pq.pop
    next if visited.include?(curr.visited_info)

    visited.add(curr.visited_info)

    x1 = curr.x + curr.direction[1]
    y1 = curr.y + curr.direction[0]

    next if x1 < 0 || y1 < 0 || x1 > graph[0].length - 1 || y1 > graph.length - 1

    new_cost = curr.cost + graph[y1][x1]

    return new_cost \
      if (min_steps..max_steps).include?(curr.steps) && x1 == graph[0].length - 1 && y1 == graph.length - 1

    # find new directions
    DIRECTIONS.each_value do |value|
      next if value[0] + curr.direction[0] == 0 && value[1] + curr.direction[1] == 0

      new_steps = value == curr.direction ? curr.steps + 1 : 1

      next if new_steps > max_steps || (curr.steps < min_steps && value != curr.direction)

      pq.push(WalkPath.new(new_cost, x1, y1, value, new_steps))
    end
  end
end

# p part_one_answer
# 1001

# p part_two_answer
# 1197, ~150s

### PQueue examples
#
# w1 = WalkPath.new(9, 0, 0, [0, -1], 4)
# w2 = WalkPath.new(10, 0, 0, [0, -1], 10)

# pq = PQueue.new { |a, b| a.cost < b.cost }
# pq.push(w1)
# pq.push(w2)
# pq.pop
