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

def _count_steps(maps, steps)
  maps = _parse(maps)
  cnt = 0
  current_point = "AAA"
  finish_point = "ZZZ"
  left_right = { "L" => 1..3, "R" => 6..8 }

  while current_point != finish_point
    cnt += 1
    instruction = steps.next
    current_point = maps[current_point][left_right[instruction]]
  end

  cnt
end

def _count_ghost_steps(maps, steps)
  maps = _parse(maps)
  current_points = _start_points(maps)
  cnt = 0
  left_right = { "L" => 1..3, "R" => 6..8 }

  # maps.values.filter { |v| v[6..8].end_with?("Z") }
  # maps.filter { |k, v| k.end_with?("Z") }

  until _end_point?(current_points)
    cnt += 1
    instruction = steps.next
    current_points = current_points.values.each_with_object({}) do |point, acc|
      key = point[left_right[instruction]]
      acc[key] = maps[key] 
    end
  end

  cnt
end

def _start_points(maps)
  maps.filter { |k, v| k.end_with?("A") }
end

def _end_point?(maps)
  p maps
  maps.keys.all? { |k| k.end_with?("Z") }
end

def _parse(maps)
  maps.each_with_object({}) do |m, h|
    t = m.split(" = ")
    h[t.first] = t.last
  end
end

data = <<~INPUT
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
INPUT

# p part_one_answer
# 19_631

# p part_two_answer
