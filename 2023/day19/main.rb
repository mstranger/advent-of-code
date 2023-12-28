###
### Aoc 2023. Day 19
###

def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n\n")
  workflows = data[0]
  parts = data[1]

  tbl = fill_table(workflows, {})
  input = parts.split("\n").map do |rules|
    rules[1..-2].split(",").to_h { |t| t.split("=") }.transform_values(&:to_i)
  end

  input.filter { apply(_1, tbl) == "A" }.map(&:values).flatten.sum
end

def part_two_answer(file = "input.txt")
  workflows = {}
  File.read(file).split("\n").each do |line|
    break if line.empty?

    key, conditions = line.gsub("}", "").split("{")
    workflows[key] = []
    conditions = conditions.split(",")
    conditions.each do |condition|
      check, dest = condition.split(":")
      to_check = check.split(/[\s<>]/)[0]
      workflows[key] << process(dest, to_check, check)
    end
  end

  state = [Array(1..4000), Array(1..4000), Array(1..4000), Array(1..4000)]
  walk(workflows, "in", state)
end

# ----

def fill_table(flows, dict)
  flows.split("\n").each do |flow|
    name = flow[0...flow.index("{")]
    rest = flow[flow.index("{") + 1..-2]
    result = parse_rules(rest.split("\n"))
    dict[name] = result
  end

  dict
end

def parse_rules(rules)
  steps = []

  rules.each do |rule|
    rule.split(",").each do |part|
      if part.include?(":")
        el = part[0]
        op = part[1]
        num = part.scan(/\d+/).first.to_i
        res = part[part.index(":") + 1..]
        steps << ->(h) { res if h[el].public_send(op, num) }
      else
        steps << ->(_h) { part }
      end
    end
  end

  steps
end

def apply(part, dict)
  current = dict["in"]

  loop do
    res = current.each do |fn|
      next unless fn.call(part)

      break fn.call(part)
    end

    return res if %w[A R].include?(res)

    current = dict[res]
  end
end

def process(dest, to_check, check)
  return ->(x, m, a, s) { [check, [x, m, a, s], [x, m, a, s]] } unless dest

  lambda do |x, m, a, s|
    [
      dest,
      [
        to_check == "x" ? x.select { |x| eval(check) } : x,
        to_check == "m" ? m.select { |m| eval(check) } : m,
        to_check == "a" ? a.select { |a| eval(check) } : a,
        to_check == "s" ? s.select { |s| eval(check) } : s
      ],
      [
        to_check == "x" ? x.reject { |x| eval(check) } : x,
        to_check == "m" ? m.reject { |m| eval(check) } : m,
        to_check == "a" ? a.reject { |a| eval(check) } : a,
        to_check == "s" ? s.reject { |s| eval(check) } : s
      ]
    ]
  end
end

def walk(workflows, next_step, state)
  return state.map(&:count).reduce(:*) if next_step == "A"
  return 0 if next_step == "R"

  num = 0
  workflows[next_step].each do |op|
    next_step, matches, non_matches = op.call(*state)
    num += walk(workflows, next_step, matches)
    state = non_matches
  end

  num
end

# p part_one_answer
# 353_046

# p part_two_answer
# 125_355_665_599_537, ~17s
