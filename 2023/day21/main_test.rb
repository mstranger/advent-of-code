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
    assert_equal 16, part_two_answer(@file, 6)
    assert_equal 50, part_two_answer(@file, 10)
  end
end
