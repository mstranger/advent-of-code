###
### Aoc 2023. Day 23
###

# TODO: here
def part_one_answer(file = "input.txt")
  map = {}
  start = nil
  target = nil

  dirs = {
    "S" => [true, true, true, true],
    "F" => [true, true, true, true],
    "." => [true, true, true, true],
    "#" => [false, false, false, false],
    ">" => [false, false, true, false],
    "<" => [true, false, false, false],
    "^" => [false, true, false, false],
    "v" => [false, false, false, true],
    nil => [false, false, false, false]
  }

  data = File.read(file).split("\n")
  data.each_with_index do |line, y|
    line.chars.each_with_index do |ch, x|
      coord = "#{x},#{y}"
      start = coord if y == 0 && ch == "."
      target = coord if y == data.length - 1 && ch == "."
      map[coord] = ch
    end
  end

  visited = {}
  go_forward(map, dirs, target, start, visited, 0)
end

def part_two_answer(file = "input.txt")
  data = File.read(file).split("\n")
  n, m = data.length, data[0].length
  start = [0, 1]
  finish = [n - 1, m - 2]

  table = fill_table(data, n, m)

  cache = {}
  cache[start] = true

  dfs(table, start, finish, 0, cache, 0)
end

# ----

def go_forward(map, dirs, target, next_step, visited, steps)
  x, y = next_step.split(",").map(&:to_i)

  visited[next_step] = true

  return steps if next_step == target

  to_visit = []
  [[x - 1, y], [x, y - 1], [x + 1, y], [x, y + 1]].each_with_index do |(x1, y1), i|
    coord = "#{x1},#{y1}"
    val = map[coord]
    can_visit = dirs[val][i]
    can_visit = false unless visited[coord].nil?
    to_visit[i] = [coord, can_visit]
  end

  lengths = []
  lengths << go_forward(map, dirs, target, to_visit[0][0], visited.clone, steps + 1) if to_visit[0][1]
  lengths << go_forward(map, dirs, target, to_visit[1][0], visited.clone, steps + 1) if to_visit[1][1]
  lengths << go_forward(map, dirs, target, to_visit[2][0], visited.clone, steps + 1) if to_visit[2][1]
  lengths << go_forward(map, dirs, target, to_visit[3][0], visited.clone, steps + 1) if to_visit[3][1]
  lengths.max || 0
end

# part 2

def neighbours(data, pos)
  x, y = pos
  n, m = data.length, data[0].length

  dirs = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
  dirs.filter do |i, j|
    i >= 0 && j >= 0 && i < n && j < m && data[i][j] != "#"
  end
end

def fill_table(data, n, m)
  start = [0, 1]
  finish = [n - 1, m - 2]

  points = [start]
  (0...n).each do |i|
    (0...m).each do |j|
      points << [i, j] if neighbours(data, [i, j]).length > 2
    end
  end

  points << finish

  points.each_with_object({}) do |b, g|
    neighbours(data, b).each do |v|
      prev, curr = b, v
      d = 1

      while !points.include?(curr)
        prev, curr = curr, neighbours(data, curr).filter { |e| e != prev }.first
        d += 1
      end

      g.key?(b) ? g[b].push([curr, d]) : g[b] = [[curr, d]]
    end
  end
end

def dfs(map, start, finish, init, visited, max)
  return [init, max].max if start == finish

  map[start].each do |v, d|
    next if visited.key?(v)

    visited[v] = true
    max = [dfs(map, v, finish, init + d, visited, max), max].max
    visited.delete(v)
  end

  max
end

# p part_one_answer
# 2074, ~3.5s

# p part_two_answer
# 6494, ~180s
