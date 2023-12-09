###
### Aoc 2023. Day 9
###

def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n")

  data.map do |s|
    current = _extrapolate(s.split.map(&:to_i), [])
    _predict_next_value(current)
  end.sum
end

def part_two_answer(file = "input.txt")
  data = File.read(file).split("\n")

  data.map do |s|
    current = _extrapolate(s.split.map(&:to_i), [])
    _predict_backward_value(current)
  end.sum
end

def _extrapolate(numbers, acc)
  if numbers.uniq == [0]
    acc << numbers
    return acc
  end

  acc << numbers
  numbers = (0...numbers.length - 1).map { |i| numbers[i + 1] - numbers[i] }
  _extrapolate(numbers, acc)
end

def _predict_next_value(numbers)
  last_column = numbers.map { [_1.last] }
  last_column[-1] << 0
  (last_column.length - 2).downto(0) do |i|
    val = last_column[i + 1].last + last_column[i].first
    last_column[i] << val
  end

  last_column.first.last
end

def _predict_backward_value(numbers)
  first_column = numbers.map { [_1.first] }
  first_column.last.unshift(0)
  (first_column.length - 2).downto(0) do |i|
    val = first_column[i].first - first_column[i + 1].first
    first_column[i].unshift(val)
  end

  first_column.first.first
end

# p part_one_answer
# 1_725_987_467

# p part_two_answer
# 971
