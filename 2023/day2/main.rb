###
### AoC 2023. Day 2
###

# only 12 red cubes, 13 green cubes, and 14 blue cubes
CUBES = {
  "red" => 12,
  "green" => 13,
  "blue" => 14
}

def part_one_answer(file = "input.txt")
  data = File.read(file)
  games = data.split("\n")

  games.reduce(0) do |acc, game|
    t = _parse(game)
    acc += t[0] if t[1].all? { CUBES[_1] >= _2 }
    acc
  end
end

def part_two_answer(file = "input.txt")
  data = File.read(file)
  games = data.split("\n")
  games.map do |game|
    _parse(game).last.values.reduce(:*)
  end.sum
end

def _parse(game)
  id_idx = game.index(":")
  rounds = game[id_idx + 1..].split(";")
  id = game[..id_idx - 1].delete_prefix("Game ").to_i

  cubes = rounds.each_with_object(Hash.new(0)) do |round, acc|
    round.scan(/\d+\s\w+/).each do |roll|
      t = roll.split(" ")
      acc[t[1]] = [t[0].to_i, acc[t[1]]].max
    end
  end

  [id, cubes]
end

# p part_one_answer
# => 2617
# p part_two_answer
# => 59_795
