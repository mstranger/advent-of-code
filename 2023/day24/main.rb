###
### Aoc 2023. Day 24
###

MIN = 200_000_000_000_000
MAX = 400_000_000_000_000

def part_one_answer(file, min, max)
  data = parse(File.read(file))

  total_cross = 0
  data.combination(2).each do |point1, point2|
    x, y = crossing(point1, point2)

    inside = (min..max).include?(x) && (min..max).include?(y)
    point1_positive = ((x - point1[:x]) / point1[:vx]) > 0
    point2_positive = ((x - point2[:x]) / point2[:vx]) > 0
    total_cross += 1 if inside && point1_positive && point2_positive
  end

  total_cross
end

def part_two_answer
end

def parse(data)
  data.split("\n").each_with_object([]) do |line, acc|
    x, y, z, vx, vy, vz =  line.split(" @ ").map { _1.split(", ").map(&:to_f) }.flatten
    acc << { x:, y:, z:, vx:, vy:, vz: }
  end
end

def crossing(point1, point2)
  m1 = point1[:vy] / point1[:vx]
  m2 = point2[:vy] / point2[:vx]
  a = m1
  b = m2
  c = point1[:y] - (m1 * point1[:x])
  d = point2[:y] - (m2 * point2[:x])

  x = (d - c) / (a - b)
  y = a * x + c

  [x, y]
end

# ---

data = <<~INPUT
  19, 13, 30 @ -2,  1, -2
  18, 19, 22 @ -1, -1, -2
  20, 25, 34 @ -2, -2, -4
  12, 31, 28 @ -1, -2, -1
  20, 19, 15 @  1, -5, -3
INPUT

# p part_one_answer("input.txt", MIN, MAX)
# 25_810
