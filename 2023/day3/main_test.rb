require "minitest/autorun"
require_relative "main"

class Day3Test < Minitest::Test
  def setup
    @file = "example.txt"

    @data = <<~INPUT
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
    INPUT

    File.write(@file, @data)
  end
  
  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 4361, part_one_answer(@file)
  end

  def test_part_two
    assert_equal 467835, part_two_answer(@file)
  end

  def test_part_two_when_gear_different_from_asterisk
    idx = @data.index("*")
    @data[idx] = "#"
    File.write(@file, @data)
    assert_equal 451490, part_two_answer(@file)
  end
end
