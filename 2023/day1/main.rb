###
### AoC 2023. Day 1
###

DIGITS = {
  "one" => "1", "two" => "2", "three" => "3",
  "four" => "4", "five" => "5", "six" => "6",
  "seven" => "7", "eight" => "8", "nine" => "9"
}.freeze

PATTERN_PLAIN = Regexp.new "\\d|(#{DIGITS.keys.join('|')})"
PATTERN_REVERSE = Regexp.new "\\d|(#{DIGITS.keys.map(&:reverse).join('|')})"

def calibration_value(line)
  result = _calibration_value_left(line) + _calibration_value_right(line)
  result.to_i
end

def _calibration_value_left(line)
  key = line.match(PATTERN_PLAIN).to_s
  key.length > 1 ? DIGITS[key] : key
end

def _calibration_value_right(line)
  key = line.reverse.match(PATTERN_REVERSE).to_s
  key.length > 1 ? DIGITS[key.reverse] : key
end

def answer(file = "input.txt")
  sum = 0
  File.open(file, "r") do |f|
    f.each_line do |line|
      sum += calibration_value(line)
    end
  end

  sum
end

# puts answer
# => 54925
