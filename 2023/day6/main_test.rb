require "minitest/autorun"
require_relative "main"

class Day6Test < Minitest::Test
  def setup
    @file = "example.com"

    data = <<~INPUT
      Time:      7  15   30
      Distance:  9  40  200
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 288, part_one_answer(@file)
  end
  
  def test_part_two
    assert_equal 71503, part_two_answer(@file)
  end
end
