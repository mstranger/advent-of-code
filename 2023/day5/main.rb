###
### AoC 2023. Day 5
###

class Range
  def intersection(other)
    return nil if (self.end < other.begin or other.end < self.begin) 

    [self.begin, other.begin].max..[self.end, other.end].min
  end

  # def difference(other)
  #   return unless other
  #   return nil unless self.intersection(other)
  #   return if intersection(other) == self
  #   return other.end + 1..self.end if other.end < self.end
  #   return other.begin..self.begin - 1 if other.begin < self.begin
  # end

  # alias_method :&, :intersection
end

MAPS = {
  "seed-to-soil" => {},
  "soil-to-fertilizer" => {},
  "fertilizer-to-water" => {},
  "water-to-light" => {},
  "light-to-temperature" => {},
  "temperature-to-humidity" => {},
  "humidity-to-location" => {}
}.freeze


ORDER = ["seed-to-soil", "soil-to-fertilizer", "fertilizer-to-water", "water-to-light",
         "light-to-temperature", "temperature-to-humidity", "humidity-to-location"].freeze

def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n\n")
  _fill_maps(data[1..])
  
  min_location = Float::INFINITY
  seeds = data[0].delete_prefix("seeds: ").split.map(&:to_i)
  seeds.each do |seed|
    min_location = [_find_location(seed), min_location].min
  end

  min_location
end

def part_two_answer(data)
  data = data.split("\n\n")
  _fill_maps(data[1..])

  seeds = data[0].delete_prefix("seeds: ").split.map(&:to_i)
  sts = MAPS["seed-to-soil"]

  seed_ranges = seeds.each_slice(2).map { |s| (s[0]..s[0] + s[1] - 1) }

  seeds_soil_map = {}
  seed_ranges.each { |r1| _find_intersection(sts, r1, seeds_soil_map) }

  seeds_soil_map

  res = _composition(seeds_soil_map, MAPS["soil-to-fertilizer"])
  res = _composition(res, MAPS["fertilizer-to-water"])

  res
end

def _composition(source, target)
  acc = {}
  source.each do |s_k, s_v|
    if target.keys.all? { |t_k| s_v.intersection(t_k).nil? }
      acc[s_k] = s_v
      next
    end

    target.each do |t_k, t_v|
      next unless s_v.intersection(t_k)

      inter = s_v.intersection(t_k)

      if inter == s_v
        next
      end

      if inter == t_k
        next
      end

      if inter.begin == t_k.begin
        next
      end

      if inter.end == t_k.end
        next
      end
    end
  end

  acc
end

# def _split_ranges(ranges_map, r, res)
#   if ranges_map.keys.all? { |k| r.intersection(k).nil? }
#     res[r] = r
#     return res
#   end
#
#   ranges_map.each_key do |k|
#     inter = k.intersection(r)
#     next unless inter
#
#     diff = r.difference(inter)
#
#     _find_intersection(ranges_map, inter, res)
#     _find_intersection(ranges_map, diff, res)
#   end
# end

def _find_intersection(map_ranges, target, acc)
  if map_ranges.keys.all? { |r| r.intersection(target).nil? && target.begin <= target.end }
    acc[target] = target
    return
  end

  map_ranges.keys.each do |r|
    if r.intersection(target) == target
      shift = target.begin - r.begin
      start = map_ranges[r].begin + shift
      acc[target] = (start..start + target.size - 1)
    elsif r.intersection(target) == r
      _find_intersection(map_ranges, target.begin..r.begin - 1, acc)
      _find_intersection(map_ranges, r, acc)
      _find_intersection(map_ranges, r.end + 1..target.end, acc)
    elsif r.intersection(target).nil?
      next
    elsif (r.begin >= target.begin) & (r.begin <= target.end)
      _find_intersection(map_ranges, r.begin..target.end, acc)
      _find_intersection(map_ranges, target.begin..r.begin - 1, acc)
    elsif (target.begin <= r.end) & (target.end >= r.end)
      _find_intersection(map_ranges, target.begin..r.end, acc)
      _find_intersection(map_ranges, r.end + 1..target.end, acc)
    end
  end
end

def _fill_maps(data)
  data.each do |record|
    title, instructions = record.split(" map:\n")
    instructions.split("\n").each do |line|
      dest, src, len = line.split.map(&:to_i)
      MAPS[title][src..src + len - 1] = (dest..dest + len - 1)
    end
  end
end

def _find_location(target)
  ORDER.each { |key_map| target = _traverse(target, key_map) }
  target
end

def _traverse(target, key)
  src, dest = MAPS[key].select { _1 === target }.to_a.first
  return target unless src

  dest.first + target - src.first
end


# ---

data = <<~INPUT
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
INPUT

# p part_one_answer
# 26_273_516

p part_two_answer(data)
# p part_two_answer(File.read("input.txt"))

