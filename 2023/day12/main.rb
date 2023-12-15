###
### Aoc 2023. Day 12
###

# NOTE: it takes about 52s
def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n")

  data.map do |line|
    pattern, seq = line.split
    pattern = pattern.chars
    seq = seq.split(",").map(&:to_i)
    solve(pattern, seq)
  end.sum
end

def part_two_answer
end

# ----

def solve(chars, seq)
  indexes = chars.each_with_index.filter_map { |ch, i| i if ch == "?" }
  (0...2**indexes.length).count do |e|
    # TODO: here
    indexes.each_with_index { |i, j| chars[i] = (e & (1 << j)) == 0 ? "." : "#" }
    arrangement(chars.join) == seq
  end
end

def arrangement(line)
  line.scan(/(#+)/).map { _1.first.length }
end

data = <<~INPUT
  ???.### 1,1,3
  .??..??...?##. 1,1,3
  ?#?#?#?#?#?#?#? 1,3,1,6
  ????.#...#... 4,1,1
  ????.######..#####. 1,6,5
  ?###???????? 3,2,1
INPUT

# p part_one_answer
# 7163
