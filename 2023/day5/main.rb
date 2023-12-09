###
### AoC 2023. Day 5
###

class Range
  def intersection(other)
    return nil if self.end < other.begin || other.end < self.begin 

    [self.begin, other.begin].max..[self.end, other.end].min
  end
end

ORDER = ["seed-to-soil", "soil-to-fertilizer", "fertilizer-to-water", "water-to-light",
         "light-to-temperature", "temperature-to-humidity", "humidity-to-location"].freeze

def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n\n")
  maps = _fill_maps(data[1..])

  min_location = Float::INFINITY
  seeds = data[0].delete_prefix("seeds: ").split.map(&:to_i)
  seeds.each do |seed|
    min_location = [_find_location_bf(seed, maps), min_location].min
  end

  min_location
end

def part_two_answer(file = "input.txt")
  data = File.read(file).split("\n\n")
  maps = _fill_maps(data[1..])

  seeds = data[0].delete_prefix("seeds: ").split.map(&:to_i)
  seed_ranges = seeds.each_slice(2).map { |s| (s[0]..s[0] + s[1] - 1) }
  seed_ranges = seed_ranges.each_with_object({}) { |r, h| h[r] = r }

  locations = _find_locations(seed_ranges, maps).values
  locations.map(&:begin).min
end

# build map seeds => locations
def _find_locations(ranges, maps)
  ORDER.each do |key|
    map = _split_multi_hashes(ranges, maps[key])
    ranges = _build_new_map(map)
  end
  ranges
end

# process input and build a hash
def _fill_maps(data)
  maps = ORDER.each_with_object({}) { |k, h| h[k] = {} }

  data.each do |record|
    title, instructions = record.split(" map:\n")
    instructions.split("\n").each do |line|
      dest, src, len = line.split.map(&:to_i)
      maps[title][src..src + len - 1] = (dest..dest + len - 1)
    end
  end

  maps
end

# using brute force method
def _find_location_bf(target, maps)
  ORDER.each { |key_map| target = _traverse_next(target, maps[key_map]) }
  target
end

def _traverse_next(target, key)
  src, dest = key.select { _1 === target }.to_a.first
  return target unless src

  dest.first + target - src.first
end

# split one hash in which key/value are ranges by range key of other hash
# both arguments has only one element
#
# example
#   in:  {1..5 => 7..11} x {9..15 => 14..20}
#   out: { source: {1..2 => 7..8, 3..5 => 9..11},
#          target: {9..11 => 14..16, 12..15 => 17..20} }
#
def _split_range_hashes(h1, h2)
  src_val = h1.values.first
  src_key = h1.keys.first
  tgt_key = h2.keys.first
  tgt_val = h2.values.first

  inter = src_val.intersection(tgt_key)
  return {} unless inter

  if inter == src_val
    h1_res = h1
    h2_res = {}
    ranges = [tgt_key.begin..inter.begin - 1, inter, inter.end + 1..tgt_key.end].reject { |r| r.end < r.begin }
    ranges.each do |r|
      shift = r.begin - tgt_key.begin
      h2_res[r] = tgt_val.begin + shift..tgt_val.begin + shift + r.size - 1
    end

    return { source: h1_res, target: h2_res }
  end

  if inter == tgt_key
    h1_res = {}
    h2_res = h2
    ranges = [src_val.begin..inter.begin - 1, inter, inter.end + 1..src_val.end].reject { |r| r.end < r.begin }
    ranges.each do |r|
      shift = r.begin - src_val.begin
      key = src_key.begin + shift..src_key.begin + shift + r.size - 1
      h1_res[key] = r
    end

    return { source: h1_res, target: h2_res }
  end

  if inter.begin == tgt_key.begin && inter.end < tgt_key.end
    h1_res = {}
    h2_res = {}
    src_ranges = [src_val.begin..inter.begin - 1, inter].reject { |r| r.end < r.begin }
    tgt_ranges = [inter, inter.end + 1..tgt_key.end].reject { |r| r.end < r.begin }
    src_ranges.each do |r|
      shift = r.begin - src_val.begin
      key = src_key.begin + shift..src_key.begin + shift + r.size - 1
      h1_res[key] = r
    end
    tgt_ranges.each do |r|
      shift = r.begin - tgt_key.begin
      h2_res[r] = tgt_val.begin + shift..tgt_val.begin + shift + r.size - 1
    end

    return { source: h1_res, target: h2_res }
  end

  if inter.end == tgt_key.end && inter.begin > tgt_key.begin
    h1_res = {}
    h2_res = {}
    src_ranges = [inter, inter.end + 1..src_val.end]
    tgt_ranges = [tgt_key.begin..inter.begin - 1, inter]
    src_ranges.each do |r|
      shift = r.begin - src_val.begin
      key = src_key.begin + shift..src_key.begin + shift + r.size - 1
      h1_res[key] = r
    end
    tgt_ranges.each do |r|
      shift = r.begin - tgt_key.begin
      h2_res[r] = tgt_val.begin + shift..tgt_val.begin + shift + r.size - 1
    end

    return { source: h1_res, target: h2_res }
  end
end

# do same as `_split_range_hashes` method, but takes multi hashes
# (1 and more range elements) as aguments; returns a new splitted map
# output format: { source: { ... }, target: { ... } }
#
def _split_multi_hashes(src, tgt)
  res = { source: {}, target: {} }
  src.each do |src_k|
    if tgt.keys.all? { |r| r.intersection(src_k[1]).nil? }
      res[:source] = { **res[:source], src_k[0] => src_k[1] }
      res[:target] = { **res[:target], src_k[1] => src_k[1] }
    end

    tgt.each do |tgt_v|
      h = _split_range_hashes(Hash[*src_k], Hash[*tgt_v])
      next if h.empty?

      res[:source] = { **res[:source], **h[:source] }
      res[:target] = { **res[:target], **h[:target] }
    end
  end

  _split_parts_with_same_begin(res[:source])
  _split_parts_with_same_begin(res[:target])
  res
end

# join (left) hashes with ranges
# example:
#   in:  { source: {1..5 => 7..11, 10..12 => 15..17}, target: {7..11 => 21..25} }
#   out: { 1..5 => 21..25, 10..12 => 15..17 }
#
def _build_new_map(map)
  source = map[:source]
  target = map[:target]

  source.transform_values do |v|
    target.key?(v) ? target[v] : v
  end
end

# process variants when hashes has ranges with same start points
# example: { 5..7 => 9..11, 5..10 => 9..14 }
#
def _split_parts_with_same_begin(map)
  t = map.keys.group_by(&:begin).filter { _2.length > 1 }.values.first
  return unless t

  h1 = { t[0] => map[t[0]] }
  h2 = { map[t[1]] => t[1] }

  if t[0].size < t[1].size
    h1 = { t[1] => map[t[1]] }
    h2 = { map[t[0]] => t[0] }
  end

  res = _split_range_hashes(h1, h2)[:source]
  map.delete(t[0])
  map.delete(t[1])
  res.each { |k, v| map[k] = v }

  # recursively repeat
  _split_parts_with_same_begin(map)
end

# p part_one_answer
# 26_273_516

# p part_two_answer
# 34_039_469
