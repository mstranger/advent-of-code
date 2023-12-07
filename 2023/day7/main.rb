###
### AoC 2023. Day 7
###

class CamelCard
  STRENGTH = "23456789TJQKA".freeze

  attr_reader :hand, :bid

  def initialize(hand, bid)
    @hand = hand
    @bid = bid.to_i
  end

  def <=>(other)
    compare(hand, other.hand)
  end

  def inspect = hand

  def score(hand)
    h = hand.chars.tally
    case h.values.sort
    when [5] then 50          # five of a kind
    when [1, 4] then 40       # four of a kind
    when [2, 3] then 30       # full house
    when [1, 1, 3] then 20    # three of a kind
    when [1, 2, 2] then 10    # two pair
    when [1, 1, 1, 2] then 5  # one pair
    else 1                    # high card
    end
  end

  private

  def compare(hand1, hand2)
    value = score(hand1) <=> score(hand2)
    value == 0 ? clarify_comparison(hand1, hand2) : value
  end

  def clarify_comparison(hand1, hand2)
    hand1 = hand1.chars.map { self.class::STRENGTH.index(_1) }
    hand2 = hand2.chars.map { self.class::STRENGTH.index(_1) }
    hand1 <=> hand2
  end
end

class CamelCardWithJoker < CamelCard
  STRENGTH = "J23456789TQKA".freeze

  def score(hand)
    best_score = super(hand)

    STRENGTH[1..].each_char do |ch|
      candidate = hand.gsub("J", ch)
      best_score = [super(candidate), best_score].max
    end

    best_score
  end
end

def part_one_answer(file = "input.txt")
  data = File.read(file)
  cards = _parse(data, CamelCard)
  cards.sort.map.with_index { |card, i| card.bid * (i + 1) }.sum
end

def part_two_answer(file = "input.txt")
  data = File.read(file)
  cards = _parse(data, CamelCardWithJoker)
  cards.sort.map.with_index { |card, i| card.bid * (i + 1) }.sum
end

def _parse(data, cls)
  data.split("\n").map { |t| cls.new(*t.split) }
end

# p part_one_answer
# 249_638_405

# p part_two_answer
# 249_776_650
