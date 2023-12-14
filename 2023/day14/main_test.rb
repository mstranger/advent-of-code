require "minitest/autorun"
require_relative "main"

class Day14Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~INPUT
      O....#....
      O.OO#....#
      .....##...
      OO.#O....O
      .O.....O#.
      O.#..O.#.#
      ..O..#O..O
      .......O..
      #....###..
      #OO..#....
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 136, part_one_answer(@file)
  end

  def test_part_two
    assert_equal 64, part_two_answer(@file)
  end
end
