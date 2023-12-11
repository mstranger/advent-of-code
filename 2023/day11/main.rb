###
### Aoc 2023. Day 11
###

def part_one_answer(file = "input.txt", power = 2)
  data = File.read(file).split("\n")
  empties = will_expanded(data)
  galaxies = find_galaxies(data)

  get_sum_of_distances(galaxies, empties, power)
end

def part_two_answer(file, power)
  part_one_answer(file, power)
end

def will_expanded(data)
  by_x = will_expanded_x(data)
  by_y = will_expanded_y(data)
  [by_x, by_y]
end

def will_expanded_x(data)
  idxs = []
  data.each_with_index { |line, i| idxs << i if line =~ /^\.+$/ }
  idxs
end

def will_expanded_y(data)
  data = data.each.map(&:chars).transpose.map(&:join)
  will_expanded_x(data)
end

def get_sum_of_distances(galaxies, empties, power)
  empty_xs, empty_ys = empties
  power -= 1

  pairs = galaxies.keys.permutation(2)
  sum = pairs.reduce(0) do |acc, pair|
    x1, y1 = galaxies[pair[0]]
    x2, y2 = galaxies[pair[1]]

    cnt_empty_lines = empty_xs.count { |n| n.between?([x1, x2].min, [x1, x2].max) }
    cnt_empty_rows = empty_ys.count { |n| n.between?([y1, y2].min, [y1, y2].max) }

    acc + (x2 - x1).abs + (y2 - y1).abs + ((cnt_empty_lines + cnt_empty_rows) * power)
  end

  sum / 2
end

def find_galaxies(data)
  result = {}
  cnt = 1
  data.each_with_index do |row, x|
    (0..row.length - 1).each do |y|
      if data[x][y] == "#"
        result[cnt] = [x, y]
        cnt += 1
      end
    end
  end
  result
end

# p part_one_answer
# 10_276_166

# p part_two_answer("input.txt", 1_000_000)
# 598_693_078_798
