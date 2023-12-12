###
### Aoc 2023. Day 12
###

def part_one_answer(data)
  records = []
  data.split("\n").each do |line|
    t = line.split
    records << [t[0], t[1]]
  end

  records.map do |record|
    total_variants(record)
  end
end

def part_two_answer
end

def arrangement(line)
  line.scan(/(#+)/).map { _1.first.length }
end

def total_variants(record)
  line, groups = record
  len = line.length

  idx = []
  line.chars.each_with_index { |ch, i| idx << i if ch == "?" }
  idx.count

end

data = <<~INPUT
  ???.### 1,1,3
  .??..??...?##. 1,1,3
  ?#?#?#?#?#?#?#? 1,3,1,6
  ????.#...#... 4,1,1
  ????.######..#####. 1,6,5
  ?###???????? 3,2,1
INPUT

# p part_one_answer(data)
# p total_variants(["???.###.", "1,1,3"])
# p total_variants([".??..??...?##.", "1,1,3"])
# p total_variants(["?#?#?#?#?#?#?#?" "1,3,1,6"])
# p total_variants([".??..??...?##.", "1,1,3"])
# p total_variants([".??..??...?##.", "1,1,3"])
# p total_variants([".??..??...?##.", "1,1,3"])


s = "????"
len = 4
i = 0

s1 = s.dup
while i < len
  s1[i] = "."

  j = i
  s2 = s1.dup
  while j < len
    s2[j] = "*"
    j += 1
  end

  p s2

  i += 1
end
