require "minitest/autorun"
require_relative "main"

class Day11Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~INPUT
      ...#......
      .......#..
      #.........
      ..........
      ......#...
      .#........
      .........#
      ..........
      .......#..
      #...#.....
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 374, part_one_answer(@file)
  end

  def test_part_two
    assert_equal 1030, part_two_answer(@file, 10)
    assert_equal 8410, part_two_answer(@file, 100)
  end
end
