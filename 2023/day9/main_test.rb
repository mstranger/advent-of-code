require "minitest/autorun"
require_relative "main"

class Day9Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~INPUT
      0 3 6 9 12 15
      1 3 6 10 15 21
      10 13 16 21 30 45
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 114, part_one_answer(@file)
  end

  def test_part_two
    assert_equal 2, part_two_answer(@file)
  end
end
