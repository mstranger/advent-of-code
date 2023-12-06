###
### AoC 2023. Day 6
###

def part_one_answer(file = "input.txt")
  data = _parse(File.read(file))
  _build_variants(data[2]).length
  data.map { _build_variants(_1).length }.reduce(:*)
end

# takes about 4s
def part_two_answer(file = "input.txt")
  data = _correct_parse(File.read(file))
  _count_variants(data)
end

# takes about 13s
def part_two_answer_v1(file = "input.txt")
  data = _correct_parse(File.read(file))
  _build_variants(data).length
end

def _parse(data)
  time, distance = data.split("\n")
  time = time.delete_prefix("Time:").split.map(&:to_i)
  distance = distance.delete_prefix("Distance:").split.map(&:to_i)
  time.zip(distance)
end

def _correct_parse(data)
  time, distance = data.split("\n")
  time = time.delete_prefix("Time:").delete(" ").to_i
  distance = distance.delete_prefix("Distance:").delete(" ").to_i
  [time, distance]
end

def _build_variants(data)
  time, record = data[0], data[1]
  (0..time).each_with_object([]) do |ms, acc|
    expected_time = (time - ms) * ms
    acc << [ms, expected_time] if expected_time > record
  end
end

def _count_variants(data)
  time, distance = data[0], data[1]
  win_start = (0..distance).find { |ms| (time - ms) * ms > distance }
  win_end = (win_start..distance).find { |ms| (time - ms) * ms < distance }
  win_end - win_start
end

# p part_one_answer
# 128_700

# p part_two_answer
# 39_594_072
