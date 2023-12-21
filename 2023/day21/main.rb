###
### Aoc 2023. Day 21
###

# TODO: bfs
def part_one_answer(file = "input.txt", steps = 64)
  data = parse(File.read(file))

  queue = [
    { i: data[:start][0], j: data[:start][1], rest: steps }
  ]

  until queue.empty?
    step = queue.shift
    queue.push(*next_steps(data, [step[:i], step[:j]], step[:rest]))
  end

  data[:plots].values.filter(&:even?).length
end

##
#  Lagrange's interpolation formula for ax^2 + bx + c with x=[0,1,2] and y=[y0,y1,y2]:
#     f(x) = (x^2-3x+2) * y0/2 - (x^2-2x)*y1 + (x^2-x) * y2/2
#  coefficients:
#     a = y0/2 - y1 + y2/2
#     b = -3*y0/2 + 2*y1 - y2/2
#     c = y0
#
def part_two_answer(file = "input.txt", steps = 26_501_365)
  len = File.read(file).split("\n").length
  r = steps % len

  values = [
    part_one_answer(file, r),
    part_one_answer(file, r + len),
    part_one_answer(file, r + (len * 2))
  ]

  poly = lagrange(values)
  target = (steps - r) / len

  (poly[:a] * target * target) + (poly[:b] * target) + poly[:c]
end

# ----

def parse(data)
  grid = data.split("\n").map(&:chars)
  walls = {}
  plots = {}
  start = [0, 0]

  (0...grid.length).each do |i|
    (0...grid[i].length).each do |j|
      val = grid[i][j]

      walls["#{i},#{j}"] = true if val == "#"

      if val == "S"
        plots["#{i},#{j}"] = -1
        start = [i, j]
      end
    end
  end

  { walls:, plots:, start:, size: grid.length }
end

def wrapped(i, j, size)
  i %= size
  j %= size
  [
    i >= 0 ? i : size + i,
    j >= 0 ? j : size + j
  ]
end

def next_steps(grid, curr, rest)
  i, j = curr
  k = "#{i},#{j}"
  wi, wj = wrapped(i, j, grid[:size])
  wk = "#{wi},#{wj}"

  return [] if grid[:walls].key?(wk) || (grid[:plots].key?(k) && grid[:plots][k] >= rest)

  grid[:plots][k] = rest

  if rest > 0
    [
      { i: i + 1, j:, rest: rest - 1 },
      { i: i - 1, j:, rest: rest - 1 },
      { i:, j: j + 1, rest: rest - 1 },
      { i:, j: j - 1, rest: rest - 1 }
    ]
  else
    []
  end
end

def lagrange(values)
  {
    a: ((values[0] + values[2]) / 2) - values[1],
    b: (-3 * (values[0] / 2)) + (2 * values[1]) - (values[2] / 2),
    c: values[0]
  }
end

# p part_one_answer
# 3782

# p part_two_answer
# 630_661_863_455_116, ~3s
