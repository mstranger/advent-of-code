###
### AoC 2023. Day 4
###

def part_one_answer(file = "input.txt")
  data = File.read(file)
  lines = data.split("\n")
  lines.reduce(0) do |acc, line|
    matches = _find_match_numbers(line)
    matches.empty? ? acc : acc + 2**(matches.length - 1)
  end
end

# return guessed numbers for one game
def _find_match_numbers(line)
  idx = line.index(":")
  _title = line[..idx - 1]
  winner, current = line[idx + 1..].split(" | ")
  winner, current = winner.split, current.split
  winner & current
end

def part_two_answer(file = "input.txt")
  data = File.read(file)
  lines = data.split("\n")
  matches = lines.map do |line|
    [1, _find_match_numbers(line).length]
  end

  _count_all_cards(matches).map(&:first).sum
end

# find count of each card after duplication
def _count_all_cards(matches)
  matches.each_with_index do |match, i|
    matches[i + 1..i + match.last].each do |t|
      t[0] += matches[i][0]
    end
  end
end

# p part_one_answer
# 25_651

# p part_two_answer
# 19_499_881
