###
### Aoc 2023. Day 14
###

def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n")
  rolled = roll_north(data)
  total_load(rolled)
end

def part_two_answer(file = "input.txt", n = 1_000_000_000)
  data = File.read(file).split("\n")

  seen = {}
  idx = (1..).each do |i|
    data = cycle(data)
    if seen.key?(data.join("\n"))
      cycle_length = i - seen[data.join("\n")]
      break seen[data.join("\n")] + (n - seen[data.join("\n")]) % cycle_length
    end
    seen[data.join("\n")] = i
  end

  seen.each do |k, v|
    return total_load(k.split("\n")) if v == idx
  end
end

# ----

def total_load(data)
  data.reverse.map.with_index { |row, i| row.count(?O) * (i + 1) }.sum
end

# clockwise rotation
def rotate(data)
  data.map(&:chars).transpose.map(&:reverse).map(&:join)
end

def cycle(data)
  n = roll_north(data)
  w = roll_north(rotate(n))
  s = roll_north(rotate(w))
  e = roll_north(rotate(s))
  rotate(e)
end

def roll_north(data)
  rows = data.length
  cols = data.first.length

  (0...cols).each do |j|
    (0...rows).each do |i|
      if data[i][j] == "O"
        move_up(data, i, j)
      end
    end
  end

  data
end

def move_up(data, i, j)
  return if i == 0

  i1 = (i - 1).downto(0) do |k|
    break k if data[k][j] == "O" || data[k][j] == "#" || k == 0
  end

  i1 += 1 if data[i1][j] != "."
  data[i][j], data[i1][j] =  data[i1][j], data[i][j]
end

# puts part_one_answer
# 109_098

# puts part_two_answer
# 100_064, ~4.5s
