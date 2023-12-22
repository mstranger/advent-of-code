###
### Aoc 2023. Day 22
###

def part_one_answer(file = "input.txt")
  input = File.read(file).split("\n")
  bricks, _, above, below = parse(input)

  bricks.find_all do |b|
    above[b].all? { below[_1].size > 1 }
  end.size
end

def part_two_answer(file = "input.txt")
  input = File.read(file).split("\n")
  bricks, _, above, below = parse(input)

  bricks.map do |b|
    f = [b].uniq
    q = above[b].to_a
    while (t = q.shift)
      next if f.include?(t)
      next unless below[t].all? { f.include?(_1) }

      f << t
      q += above[t].to_a
    end

    f.size - 1
  end.sum
end

# ----

Brick = Struct.new(:x1, :y1, :z1, :x2, :y2, :z2)

def parse(data)
  bricks = data.map { |b| Brick.new(*b.scan(/\d+/).map(&:to_i)) }.sort_by(&:z1)
  grid = {}
  bricks.each do |b|
    all_points(*b).each { |x, y, z| grid[[x, y, z]] = b }
  end

  handle_falling(bricks, grid)

  above = bricks_by_condition(grid, bricks, 1)
  below = bricks_by_condition(grid, bricks, -1)

  [bricks, grid, above, below]
end

def all_points(x1, y1, z1, x2, y2, z2)
  (x1..x2)
    .to_a
    .product((y1..y2).to_a)
    .product((z1..z2).to_a)
    .map { [_1[0][0], _1[0][1], _1[1]] }
end

# drop bricks by decrement z coordinate
def handle_falling(bricks, grid)
  bricks.each do |b|
    until b.z1 == 1
      points = all_points(*b)
      break if points.any? { |x, y, z| grid[[x, y, z - 1]] && grid[[x, y, z - 1]] != b }

      points.each do |x, y, z|
        grid.delete([x, y, z])
        grid[[x, y, z - 1]] = b
      end

      b.z2 -= 1
      b.z1 -= 1
    end
  end
end

def bricks_by_condition(grid, bricks, val)
  bricks.to_h do |b|
    [b, all_points(*b).map do |x, y, z|
      grid[[x, y, z + val]] if grid[[x, y, z + val]] && grid[[x, y, z + val]] != b
    end.compact.uniq]
  end
end

# p part_one_answer
# 418, ~1s

# p part_two_answer
# 70_702, ~13s
