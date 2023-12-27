###
### Aoc 2023. Day 10
###

def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n")
  walk(data).size / 2
end

def part_two_answer(file = "input.txt")
  data = File.read(file).split("\n")
  visited = walk(data).to_a

  vertices = []
  visited.size.times do |i|
    y, x = visited[i]
    vertices << [y, x] if %w[F 7 L J].include?(data[y].chars[x])
  end

  picks_interior(shoelace(vertices), visited.size).to_i
end

# ----

def walk(data)
  y = data.find_index { |row| row.index("S") }
  x = data[y].index("S")

  visited = [[y, x]].to_set

  next_items = []

  # originally started 2 directions at once and counted steps to meet in the middle
  # but shoelace wants all vertices in order, so change to launche one search node
  if ["F", "|", "7"].include?(data[y - 1][x])
    next_items << [[y - 1, x], [-1, 0], 1]
  elsif ["L", "|", "J"].include?(data[y + 1][x])
    next_items << [[y + 1, x], [1, 0], 1]
  elsif ["L", "-", "F"].include?(data[y][x - 1])
    next_items << [[y, x - 1], [0, -1], 1]
  elsif ["7", "-", "J"].include?(data[y][x + 1])
    next_items << [[y, x + 1], [0, 1], 1]
  end

  until next_items.empty?
    curr, vec = next_items.shift
    visited << curr
    case data[curr[0]][curr[1]]
    when "-", "|" # vector stays the same
    when "F", "J" then vec = [-1 * vec[1], -1 * vec[0]]
    when "L", "7" then vec = [vec[1], vec[0]]
    end

    unless visited.include?([curr[0] + vec[0], curr[1] + vec[1]])
      next_items.push([[curr[0] + vec[0], curr[1] + vec[1]], vec])
    end
  end

  visited
end

# https://en.wikipedia.org/wiki/Shoelace_formula
# area inside a polygon given by the following product/sum of all vertices:
# A = 1/2*(x0*y1 - x1*y0 + .... x999*y1000 - x1000*y999)
def shoelace(vertices)
  sum1 = 0
  sum2 = 0

  vertices.each_with_index do |(x, y), i|
    next_vertex = vertices[(i + 1) % vertices.size]
    sum1 += x * next_vertex[1]
    sum2 += y * next_vertex[0]
  end

  (sum1 - sum2).abs / 2.0
end

# gives number of integer points within a simple polygon
def picks_interior(area, boundary_len)
  area - (boundary_len / 2.0) + 1
end

# p part_one_answer
# 6599

# p part_two_answer
# 477
