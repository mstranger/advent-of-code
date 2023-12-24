require "minitest/autorun"
require_relative "main"

class Day24Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~INPUT
      19, 13, 30 @ -2,  1, -2
      18, 19, 22 @ -1, -1, -2
      20, 25, 34 @ -2, -2, -4
      12, 31, 28 @ -1, -2, -1
      20, 19, 15 @  1, -5, -3
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 2, part_one_answer(@file, 7, 27)
  end

  def test_part_two
    skip
    assert_equal 0, part_two_answer(@file)
  end
end
