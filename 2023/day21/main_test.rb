require "minitest/autorun"
require_relative "main"

class Day21Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~INPUT
      ...........
      .....###.#.
      .###.##..#.
      ..#.#...#..
      ....#.#....
      .##..S####.
      .##..#...#.
      .......##..
      .##.#.####.
      .##..##.##.
      ...........
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 16, part_one_answer(@file, 6)
  end

  def test_part_two
    skip
    assert_equal 0, part_two_answer(@file)
  end
end
