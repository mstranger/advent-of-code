###
### Aoc 2023. Day 18
###

def part_one_answer(file = "input.txt")
  instructions = parse(File.read(file).split("\n"))

  # define max field's size if start point in the center
  n = instructions.map { _1[1] }.sum
  res = Array.new((2 * n) + 3) { Array.new((2 * n) + 3) { "." } }

  drow_stroke(res, instructions)

  fill_stroke(res)

  res.map { _1.count("#") }.sum
end

def part_two_answer(file = "input.txt")
  data = File.read(file).split("\n")

  points, bounds = drow_stroke_fast(data)
  points.pop # end point == start point

  sum = 0
  points[..-2].each_with_index do |(x1, y1), i|
    x2, y2 = points[i + 1]
    sum += (y1 + y2) * (x1 - x2)
  end

  ((sum - bounds) / 2) + bounds + 1
end

# ----

DIR_MAPS = { "U" => "up", "D" => "down", "L" => "left", "R" => "right" }.freeze

DIRS = {
  "up" => { "R" => [0, 1], "L" => [0, -1] },
  "down" => { "R" => [0, 1], "L" => [0, -1] },
  "left" => { "U" => [-1, 0], "D" => [1, 0] },
  "right" => { "U" => [-1, 0], "D" => [1, 0] }
}.freeze

def parse(data)
  data.each_with_object([]) do |e, acc|
    t = e.split
    acc << [t[0], t[1].to_i]
  end
end

# drow a stroke, limit it from the outside with 'x' chars
def drow_stroke(res, instructions)
  r = res.length / 2
  dir = "up"
  i, j = [r + 1, r + 1]
  i1, j1 = [i, j]
  res[i][j] = "#"

  instructions.each do |d, n|
    x, y = DIRS[dir][d]
    if x == 0 && y != 0
      if y > 0
        res[i - 1][j] = "x" if res[i - 1][j] != "#"
        n.times { j += 1; res[i][j] = "#"; res[i - 1][j] = "x" }
      else
        res[i + 1][j] = "x" if res[i + 1][j] != "#"
        n.times { j -= 1; res[i][j] = "#"; res[i + 1][j] = "x" }
      end
    elsif x != 0 && y == 0
      if x > 0
        res[i][j + 1] = "x" if res[i][j + 1] != "#"
        n.times { i += 1; res[i][j] = "#"; res[i][j + 1] = "x" }
      else
        res[i][j - 1] = "x" if res[i][j - 1] != "#"
        n.times { i -= 1; res[i][j] = "#"; res[i][j - 1] = "x" }
      end
    end

    dir = DIR_MAPS[d]
  end

  raise "Not connected" if [i, j] != [i1, j1]

  res
end

def drow_stroke_fast(data)
  bounds = 0
  points = [[0, 0]]

  data.each do |line|
    _, val = line.gsub("(", "").gsub(")", "").split("#")
    val = val.chars
    dir = val.pop
    dist = val.join.to_i(16)

    bounds += dist
    x, y = points.last

    points << [x + dist, y] if dir == "0" # right
    points << [x, y + dist] if dir == "1" # down
    points << [x - dist, y] if dir == "2" # left
    points << [x, y - dist] if dir == "3" # up
  end

  raise "Not connected" if points.first != points.last

  [points, bounds]
end

def fill_stroke(data)
  data.each_with_index do |line, i|
    line.each_with_index do |ch, j|
      if ch == "#" && data[i][j - 1] == "x"
        k = j
        while data[i][k] != "x"
          data[i][k] = "#"
          k += 1
        end
      end
    end
  end
end

# p part_one_answer
# 28_911, ~18s

# p part_two_answer
# 77366737561114
