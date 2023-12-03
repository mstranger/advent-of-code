###
### AoC 2023. Day 3
###

# a part number is any number adjacent to a symbol other than `.`
def part_one_answer(file = "input.txt")
  data = File.read(file)

  visited = _traverse(data)
  visited.values.flatten.sum
end

# a gear is any `*` symbol that is adjacent to exactly two part numbers
def part_two_answer(file = "input.txt")
  data = File.read(file)

  visited = _traverse(data)
  visited.filter_map { |k, v| v.reduce(:*) if k.start_with?("*") && v.length > 1 }.sum
end

# parse input and return all symbols with their part numbers
# output format: {<symbol>-<x>-<y>: [integers]}
def _traverse(data)
  lines = data.split("\n")

  lines.each_with_index.with_object({}) do |(line, i), visited|
    line.chars.each_with_index do |ch, j|
      if ch =~ /[^\d|.]/
        visited["#{lines[i][j]}-#{i}-#{j}"] = _part_numbers(lines, [i, j])
      end
    end
  end
end

# return all part numbers for a given point
def _part_numbers(lines, xy)
  x, y = xy
  directions = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
  directions.each_with_object(Set.new) do |(x1, y1), numbers|
    if lines[x + x1][y + y1] =~ /\d/
      numbers << _expand_number(lines, [x + x1, y + y1])
    end
  end.to_a
end

# expand adjacent digits to an integer
def _expand_number(lines, xy)
  limit = lines.first.length
  x, y = xy
  j_s = j_e = y

  j_e += 1 while lines[x][j_e] =~ /\d/ && j_e < limit
  j_s -= 1 while lines[x][j_s] =~ /\d/ && j_s >= 0

  lines[x][j_s + 1..j_e - 1].to_i
end

# p part_one_answer
# 530_849

# p part_two_answer
# 84_900_879
