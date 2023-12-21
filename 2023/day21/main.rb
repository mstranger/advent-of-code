###
### Aoc 2023. Day 21
###

# TODO: recursion takes a long time after about 12 steps
def part_one_answer(file = "input.txt", steps = 64)
  data = File.read(file).split("\n").map(&:chars)
  current = find_start(data)
  make_moves(data, current, steps)

  # data.each { p _1.join }

  data.map(&:join).join.count("O")
end

def part_two_answer
end

# ----

DIRS = [[-1, 0], [0, 1], [1, 0], [0, -1]]

def find_start(data)
  data.each_with_index do |line, i|
    j = line.index("S")
    return [i, j] if j
  end
end

def make_moves(grid, curr, steps)
  i, j = curr
  return if grid[i][j] == "#" || steps == 0

  grid[i][j] = "."
  DIRS.each do |dir|
    i1 = i + dir[0]
    j1 = j + dir[1]
    next if i1 < 0 || j1 < 0 || i1 > grid.length - 1 || j1 > grid[0].length - 1

    grid[i1][j1] = "O" if grid[i1][j1] == "."
    make_moves(grid, [i1, j1], steps - 1)
  end
end

data = <<~IN
  ...........
  .....###.#.
  .###.##..#.
  ..#.#...#..
  ....#.#....
  .##..S####.
  .##..#...#.
  .......##..
  .##.#.####.
  .##..##.##.
  ...........
IN

p part_one_answer("input_test.txt", 6)
