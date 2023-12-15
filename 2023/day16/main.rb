###
### Aoc 2023. Day 16
###

def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n").map(&:chars)
  energized(data, :right, [0, 0])
end

# takes about 11s
def part_two_answer(file = "input.txt")
  data = File.read(file).split("\n").map(&:chars)
  rows = data.length
  cols = data.first.length

  max = 0
  top = (0...cols).map { |i| [[0, i], :down] }
  bottom = (0...cols).map { |i| [[rows - 1, i], :up] }
  left = (0...rows).map { |i| [[i, 0], :right] }
  right = (0...rows).map { |i| [[i, cols - 1], :left] }

  [*top, *right, *bottom, *left].each do |start, dir|
    max = [max, energized(data, dir, start)].max
  end

  max
end

# ----

def energized(data, dir, start)
  result = Marshal.load(Marshal.dump(data)) # deep clone
  make_move(data, result, dir, start, {})
  result.map { _1.count("#") }.sum
end

def make_move(src, tgt, dir, pos, seen)
  x, y = pos
  rows = src.length
  cols = src.first.length
  key = "#{x}-#{y}-#{dir}"
  directions = {
    right: [0, 1], left: [0, -1], up: [-1, 0], down: [1, 0]
  }

  if x < 0 || x >= rows || y < 0 || y >= cols || seen.key?(key)
    return
  end

  seen[key] = true

  if src[x][y] == "."
    tgt[x][y] = "#"
    x1 = x + directions[dir][0]
    y1 = y + directions[dir][1]
    make_move(src, tgt, dir, [x1, y1], seen)
    return
  end

  if src[x][y] == "-" && [:left, :right].include?(dir)
    tgt[x][y] = "#"
    x1 = x + directions[dir][0]
    y1 = y + directions[dir][1]
    make_move(src, tgt, dir, [x1, y1], seen)
    return
  end

  if src[x][y] == "|" && [:up, :down].include?(dir)
    tgt[x][y] = "#"
    x1 = x + directions[dir][0]
    y1 = y + directions[dir][1]
    make_move(src, tgt, dir, [x1, y1], seen)
    return
  end

  if src[x][y] == "\\"
    tgt[x][y] = "#"

    dir = case dir
          when :right then :down
          when :left then :up
          when :up then :left
          when :down then :right
          end

    x1 = x + directions[dir][0]
    y1 = y + directions[dir][1]

    make_move(src, tgt, dir, [x1, y1], seen)
    return
  end

  if src[x][y] == "/"
    tgt[x][y] = "#"

    dir = case dir
          when :right then :up
          when :left then :down
          when :up then :right
          when :down then :left
          end

    x1 = x + directions[dir][0]
    y1 = y + directions[dir][1]

    make_move(src, tgt, dir, [x1, y1], seen)
    return
  end

  if src[x][y] == "|" && [:right, :left].include?(dir)
    tgt[x][y] = "#"
    dir1 = :up
    dir2 = :down

    x1 = x + directions[dir1][0]
    y1 = y + directions[dir1][1]
    x2 = x + directions[dir2][0]
    y2 = y + directions[dir2][1]

    make_move(src, tgt, dir1, [x1, y1], seen)
    make_move(src, tgt, dir2, [x2, y2], seen)
    return
  end

  if src[x][y] == "-" && [:up, :down].include?(dir)
    tgt[x][y] = "#"
    dir1 = :right
    dir2 = :left

    x1 = x + directions[dir1][0]
    y1 = y + directions[dir1][1]
    x2 = x + directions[dir2][0]
    y2 = y + directions[dir2][1]

    make_move(src, tgt, dir1, [x1, y1], seen)
    make_move(src, tgt, dir2, [x2, y2], seen)
    return
  end

  raise "something is missing"
end

# p part_one_answer
# 7307

# p part_two_answer
# 7635
