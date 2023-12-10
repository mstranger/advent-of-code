###
### Aoc 2023. Day 10
###

def part_one_answer(file = "input.txt")
  data = parse(File.read(file))
  start_point = find_start(data)
  directions = possible_starts(data, start_point)

  result = directions.map { |start| go_forward(data, start, {}) }.max + 1
  result / 2
end

def part_two_answer
  raise "Not implemented"
end

def parse(data)
  data.split("\n").map(&:chars)
end

def find_start(data)
  data.each_with_index do |x, i|
    x.each_with_index do |y, j|
      return [i, j] if y == "S"
    end
  end
end

# process until the current point is equal to "S" (start)
def go_forward(data, point, visited)
  i, j = point

  loop do
    current = data[i][j]
    return visited.size if current == "S"

    visited["#{i}-#{j}"] = true

    # select next pipe, but not previous
    next_point = next_variants(current, i, j).select do |x, y|
      !visited.key?("#{x}-#{y}") && !(data[x][y] == "S" && visited.empty?)
    end.first

    i, j = next_point
  end
end

# moves from the start point
def possible_starts(data, start_point)
  i, j = start_point
  right = "-J7".include?(data[i][j + 1])
  left = "-LF".include?(data[i][j - 1])
  up = "|F7".include?(data[i - 1][j])
  down = "|LJ".include?(data[i + 1][j])

  ds = [up, right, down, left]
  [[i - 1, j], [i, j + 1], [i + 1, j], [i, j - 1]]
    .select
    .with_index { |_, idx| ds[idx] == true }
end

# next move directions
def next_variants(current, i, j)
  case current
  when "|" then [[i + 1, j], [i - 1, j]]
  when "-" then [[i, j + 1], [i, j - 1]]
  when "L" then [[i, j + 1], [i - 1, j]]
  when "J" then [[i, j - 1], [i - 1, j]]
  when "7" then [[i, j - 1], [i + 1, j]]
  when "F" then [[i + 1, j], [i, j + 1]]
  else [[i, j], [i, j]]
  end
end

# p part_one_answer
# 6599
