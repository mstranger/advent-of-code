###
### AoC 2023. Day 5
###

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

def part_two_answer(file = "input.txt")
  data = File.read(file).split("\n\n")
  _fill_maps(data[1..])

  min_location = Float::INFINITY
  seeds = data[0].delete_prefix("seeds: ").split.map(&:to_i)

  seeds.each_slice(2) do |s|
    (s[0]...s[0] + s[1]).each do |seed|
      min_location = [_find_location(seed), min_location].min
    end
  end

  min_location
end

def _fill_maps(data)
  data.each do |record|
    title, instructions = record.split(" map:\n")
    instructions.split("\n").each do |line|
      dest, src, len = line.split.map(&:to_i)
      MAPS[title][src...src + len] = (dest...dest + len)
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

# p part_one_answer
# 26_273_516

# p part_two_answer
