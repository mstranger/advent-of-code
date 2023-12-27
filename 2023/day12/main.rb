###
### Aoc 2023. Day 12
###

# it takes ~53s
def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n")

  data.map do |line|
    pattern, seq = line.split
    pattern = pattern.chars
    seq = seq.split(",").map(&:to_i)
    solve(pattern, seq)
  end.sum
end

# it taske ~0.3s
def part_one_answer_v2(file = "input.txt")
  data = File.read(file).split("\n")
  data.sum do |line|
    pattern, groups = line.split
    groups = groups.split(",").map(&:to_i)

    find_groups(pattern.chars, groups)
  end
end

# it takes ~4s
def part_two_answer(file = "input.txt")
  data = File.read(file).split("\n")
  data.sum do |line|
    pattern, groups = line.split
    groups = groups.split(",").map(&:to_i)

    pattern = ([pattern] * 5).join("?")
    groups *= 5

    find_groups(pattern.chars, groups)
  end
end

# ----

def solve(chars, seq)
  indexes = chars.each_with_index.filter_map { |ch, i| i if ch == "?" }
  (0...(2**indexes.length)).count do |e|
    # TODO: here
    indexes.each_with_index { |i, j| chars[i] = (e & (1 << j)) == 0 ? "." : "#" }
    arrangement(chars.join) == seq
  end
end

def arrangement(line)
  line.scan(/(#+)/).map { _1.first.length }
end

# recursive search
# recurse down if '#' and count for this group is correct
# recurse down if '.', breaking current group if applicable
# explore both paths above if '?'
def find_groups(pattern, groups, cache = {}, curr = 0)
  key = [pattern, groups, curr]
  return cache[key] if cache.key?(key)

  to_grow = (!groups.empty? && groups[0] > curr)
  valid = (!groups.empty? && groups[0] == curr)

  found = 0
  if pattern.empty?
    # end of pattern is end of search
    # but success means we either got here with the right group count
    # or we counted all the groups successfully before we got here
    return ((groups.empty? &&  curr == 0) || (groups.size == 1 && groups[0] == curr)) ? 1 : 0
  else
    if ["#", "?"].include?(pattern[0]) && to_grow
      # always continue counting current group
      # unless we exhausted our groups
      found += find_groups(pattern[1..], groups, cache, curr + 1)
    end
    if [".", "?"].include?(pattern[0])
      # continue not counting group
      if curr == 0
        found += find_groups(pattern[1..], groups, cache, 0)
      # break current group if it's correct, otherwise abort path
      elsif valid
        found += find_groups(pattern[1..], groups[1..], cache, 0)
      end
    end
  end

  cache[key] = found
  found
end

# p part_one_answer
# p part_one_answer_v2
# 7163

# p part_two_answer
# 17_788_038_834_112
