###
### Aoc 2023. Day 19
###

def part_one_answer(file = "input.txt")
  data = File.read(file).split("\n\n")
  workflows = data[0]
  parts = data[1]
  
  tbl = fill_table(workflows, {})
  input = parts.split("\n").map do |rules|
    rules[1..-2].split(",").map { |t| t.split("=") }.to_h.transform_values(&:to_i)
  end

  input.filter { apply(_1, tbl) == "A" }.map(&:values).flatten.sum
end

def part_two_answer
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
      next unless fn.(part)

      break fn.(part)
    end

    return res if res == "A" || res == "R"

    current = dict[res]
  end
end

data = <<~INPUT
  px{a<2006:qkq,m>2090:A,rfg}
  pv{a>1716:R,A}
  lnx{m>1548:A,A}
  rfg{s<537:gd,x>2440:R,A}
  qs{s>3448:A,lnx}
  qkq{x<1416:A,crn}
  crn{x>2662:A,R}
  in{s<1351:px,qqz}
  qqz{s>2770:qs,m<1801:hdj,R}
  gd{a>3333:R,R}
  hdj{m>838:A,pv}

  {x=787,m=2655,a=1222,s=2876}
  {x=1679,m=44,a=2067,s=496}
  {x=2036,m=264,a=79,s=2244}
  {x=2461,m=1339,a=466,s=291}
  {x=2127,m=1623,a=2188,s=1013}
INPUT

# p part_one_answer
# 353_046
