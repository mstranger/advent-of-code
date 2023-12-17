###
### Aoc 2023. Day 17
###

require "pqueue"

DIRECTIONS = {
  up: [-1, 0],
  right: [0, 1],
  down: [1, 0],
  left: [0, -1]
}.freeze

class WalkInfo
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

def dijkstra(graph, max_steps)
  pq = PQueue.new() { |a, b| a.cost < b.cost }
  # init with two possible directions
  pq.push(WalkInfo.new(0, 0, 0, DIRECTIONS[:right], 1))
  pq.push(WalkInfo.new(0, 0, 0, DIRECTIONS[:down], 1))
  visited = Set.new

  while pq.size > 0
    # get elem with min steps
    curr = pq.pop
    next if visited.include?(curr.visited_info)

    visited.add(curr.visited_info)

    x1 = curr.x + curr.direction[1]
    y1 = curr.y + curr.direction[0]

    if x1 < 0 || y1 < 0 || x1 > graph[0].length - 1 || y1 > graph.length - 1
      next
    end

    new_cost = curr.cost + graph[y1][x1]

    if curr.steps <= max_steps && x1 == graph[0].length - 1 && y1 == graph.length - 1
      return new_cost
    end

    # find new directions
    DIRECTIONS.each do |dir, value|
      if value[0] + curr.direction[0] == 0 && value[1] + curr.direction[1] == 0
          next
      end

      if value == curr.direction
        new_steps = curr.steps + 1
      else
        new_steps = 1
      end

      # skip if new counter is too high
      if new_steps > max_steps
        next
      end

      pq.push(WalkInfo.new(new_cost, x1, y1, value, new_steps))
    end
  end

  return -1
end

def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n").map { |line| line.chars.map(&:to_i) }
  dijkstra(data, 3)
end

def part_two_answer
end


data = <<~INPUT
  2413432311323
  3215453535623
  3255245654254
  3446585845452
  4546657867536
  1438598798454
  4457876987766
  3637877979653
  4654967986887
  4564679986453
  1224686865563
  2546548887735
  4322674655533
INPUT

p part_one_answer
# 1001

### PQueue examples
#
# w1 = WalkInfo.new(9, 0, 0, [0, -1], 4)
# w2 = WalkInfo.new(10, 0, 0, [0, -1], 10)

# pq = PQueue.new() { |a, b| a.cost < b.cost }
# pq.push(w1)
# pq.push(w2)
