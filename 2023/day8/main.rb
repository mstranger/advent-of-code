###
### AoC 2023. Day 8
###

def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n")
  instructions = data[0]
  maps = data[2..]
  steps = instructions.chars.cycle

  _count_steps(maps, steps)
end

def part_two_answer(file = "input.txt")
  data = File.read(file).split("\n")
  instructions = data[0]
  maps = data[2..]
  steps = instructions.chars.cycle

  _count_ghost_steps(maps, steps)
end

# brute force
def _count_steps(maps, steps)
  maps = _parse(maps)
  cnt = 0
  current_point = "AAA"
  finish_point = "ZZZ"
  left_right = { "L" => 1..3, "R" => 6..8 }

  while current_point != finish_point
    cnt += 1
    step = steps.next
    current_point = maps[current_point][left_right[step]]
  end

  cnt
end

# count steps for every 'ghost' and then find lcm of these numbers
def _count_ghost_steps(maps, steps)
  maps = _parse(maps)
  enter_set = _start_points(maps).map { |k, v| Hash[k, v] }

  distances = enter_set.map do |m|
    _go_forward(maps, m, steps)
  end

  distances.reduce(&:lcm)
end

def _go_forward(maps, current, steps)
  left_right = { "L" => 1..3, "R" => 6..8 }
  cnt = 0
  k = current.keys.first
  while true
    return cnt if k.end_with?("Z")

    cnt += 1
    step = steps.next
    k = maps[k][left_right[step]]
  end
end

def _start_points(maps)
  maps.filter { _1.end_with?("A") }
end

def _parse(maps)
  maps.each_with_object({}) do |m, h|
    t = m.split(" = ")
    h[t.first] = t.last
  end
end

# p part_one_answer
# 19_631

# p part_two_answer
# 21_003_205_388_413
