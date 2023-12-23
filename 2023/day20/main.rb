###
### Aoc 2023. Day 20
###

def part_one_answer(file = "input.txt")
  circuit = process_input(File.read(file).split("\n"))
  pulse = {}
  1000.times { |i| pulse = push_button(circuit, pulse) }
  pulse.values.sum { _1[0] } * pulse.values.sum { _1[1] }
end

# TODO: here
def part_two_answer(file = "input.txt")
  circuit = process_input(File.read(file).split("\n"))
  # inputs that drive the conjunction that drives 'rx'
  watch = circuit.values.find { |v| v[:outputs][0] == :rx }[:inputs]

  cycles = {}
  (1..).find do |i|
    pulse = push_button(circuit, {})
    # record the cycle that each conjunction input flop receives a low pulse,
    # since the flops can only toggle their state on low pulses
    watch.each { |k,v| cycles[k] = i if cycles[k].nil? && pulse[k][0] > 0 }
    # quit when found a low pulse on every flop towards the final conjunction
    watch.size == cycles.size
  end

  cycles.values.reduce(1) { |acc, i| acc.lcm(i) }
end

# ---

def process_input(data)
  all_inputs = {}
  res = data.to_h do |line|
    if line =~ /(%|&)(\w+) -> ([\w,\s]+)/
      n = Regexp.last_match(2).to_sym
      h = {
        type: Regexp.last_match(1).to_sym,
        state: 0,
        outputs: Regexp.last_match(3).split(", ").map(&:to_sym)
      }
      h[:outputs].each { |e| (all_inputs[e] ||= Set.new) << n }
      [n, h]
    elsif line =~ /broadcaster -> ([\w,\s]+)/
      n = :broadcaster
      h = {
        type: n,
        outputs: Regexp.last_match(1).split(", ").map(&:to_sym)
      }
      h[:outputs].each { |e| (all_inputs[e] ||= Set.new) << n }
      [n, h]
    end
  end

  res.each do |k, v|
    next if k == :broadcaster

    v[:inputs] = {}
    all_inputs[k].each { v[:inputs][_1] = 0 }
  end
end

def push_button(circuit, pulse)
  queue = [[0, :broadcaster, :button]]

  until queue.empty?
    op, dst, src = queue.shift
    (pulse[dst] ||= [0, 0])[op] += 1
    next unless circuit[dst]

    out = case circuit[dst][:type]
          when :broadcaster
            0
          when :%
            circuit[dst][:state] ^= 1 if op == 0
          when :&
            circuit[dst][:inputs][src] = op
            (circuit[dst][:inputs].values.all? { _1 == 1 }) ? 0 : 1
          end

    circuit[dst][:outputs].each { queue << [out, _1, dst] } if out
  end

  pulse
end

# p part_one_answer
# 856_482_136

# p part_two_answer
# 224_046_542_165_867
