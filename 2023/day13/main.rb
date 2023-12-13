###
### Aoc 2023. Day 13
###

def part_one_answer(file = "input.txt")
  patterns = File.read(file).split("\n\n")
  patterns.reduce(0) { _1 + _reflection_score(_2) }
end

def part_two_answer(file = "input.txt")
  patterns = File.read(file).split("\n\n")
  patterns.reduce(0) { _1 + _fix_smudge(_2) }
end

def _reflection_score(pattern, ignore = [])
  row, col = ignore
  row -= 1 if row
  col -= 1 if col

  row = _find_reflection_row(pattern, row)
  col = _find_reflection_col(pattern, col)

  return row * 100 if row
  return col if col

  0
end

def _fix_smudge(pattern)
  row_old = _find_reflection_row(pattern)
  col_old = _find_reflection_col(pattern)
  old_score = _reflection_score(pattern)

  (0...pattern.length).each do |i|
    next if pattern[i] == "\n"

    cp = pattern.dup
    cp[i] = pattern[i] == "." ? "#" : "."
    t = _reflection_score(cp, [row_old, col_old])
    return t if t > 0 && t != old_score
  end
end

def _find_reflection_row(pattern, ignore = nil)
  lines = pattern.split("\n")
  (0..lines.length - 2).each do |i|
    next if i == ignore

    if lines[i] == lines[i + 1]
      return i + 1 if _perfect_reflection?([i, i + 1], lines)
    end
  end

  nil
end

def _find_reflection_col(pattern, ignore = nil)
  transpose = pattern.split("\n").map(&:chars).transpose.map(&:join).join("\n")
  _find_reflection_row(transpose, ignore)
end

def _perfect_reflection?(indexes, lines)
  i_up, i_down = indexes
  while i_up > 0 && i_down < lines.length - 1
    i_up -= 1
    i_down += 1
    return false if lines[i_up] != lines[i_down]
  end

  true
end

# p part_one_answer
# 40_006

# p part_two_answer
# 28_627
