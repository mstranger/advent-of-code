require "minitest/autorun"
require_relative "main"

class Day7Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~INPUT
      32T3K 765
      T55J5 684
      KK677 28
      KTJJT 220
      QQQJA 483
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end
  
  def test_part_one
    assert_equal 6440, part_one_answer(@file)
  end

  def test_part_two
    assert_equal 5905, part_two_answer(@file)
  end
end
