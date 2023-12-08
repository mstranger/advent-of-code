require "minitest/autorun"
require_relative "main"

class Day8Test < Minitest::Test
  def setup
    @file = "example.txt"
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    data = <<~INPUT
      LLR

      AAA = (BBB, BBB)
      BBB = (AAA, ZZZ)
      ZZZ = (ZZZ, ZZZ)
    INPUT

    File.write(@file, data)

    assert_equal 6, part_one_answer(@file)
  end

  def test_part_two
    data = <<~INPUT
      LR

      11A = (11B, XXX)
      11B = (XXX, 11Z)
      11Z = (11B, XXX)
      22A = (22B, XXX)
      22B = (22C, 22C)
      22C = (22Z, 22Z)
      22Z = (22B, 22B)
      XXX = (XXX, XXX)
    INPUT

    File.write(@file, data)

    assert_equal 6, part_two_answer(@file)
  end
end
