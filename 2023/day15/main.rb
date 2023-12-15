###
### Aoc 2023. Day 15
###

def part_one_answer(file = "input.txt")
  data = File.read(file).strip.split(",")
  data.reduce(0) { |result, t| result + _hash(t) }
end

def part_two_answer(file = "input.txt")
  data = File.read(file).strip.split(",")
  pack(data).map { |n, items| box_focusing_power(n, items) }.sum
end

# ----

def _hash(string)
  string.each_byte.reduce(0) do |result, byte|
    result.+(byte).*(17).%(256)
  end
end

def pack(data)
  boxes = Hash.new([])
  cache = Hash.new([])
  data.each { |item| put_in_or_remove(boxes, item, cache) }
  boxes
end

def put_in_or_remove(store, item, cache)
  if item[-1] == "-"
    remove(store, item[..-2], cache)
  else
    put_in(store, item, cache)
  end
end

def put_in(store, item, cache)
  name, n = item.split("=")
  box_number = _hash(name)
  cache[name] = box_number
  boxes = store[box_number]
  repr = "#{name} #{n}"

  idx = boxes.index { |s| s =~ /^#{name}\s/ }
  if idx
    store[box_number][idx] = repr
  else
    store[box_number] += [repr]
  end
end

def remove(store, item, cache)
  return unless cache.key?(item)

  box = cache[item]
  idx = store[box].index { |s| s =~ /^#{item}\s/ }
  store[box].slice!(idx, 1)
  cache.delete(item)
end

def box_focusing_power(n, items)
  return 0 if items.empty?

  items.map.with_index do |item, i|
    (n + 1) * (i + 1) * item.split.last.to_i
  end.sum
end

# p part_one_answer
# 495_972

# p part_two_answer
# 245_223
