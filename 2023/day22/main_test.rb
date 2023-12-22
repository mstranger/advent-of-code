require "minitest/autorun"
require_relative "main"

class Day22Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~IN
      1,0,1~1,2,1
      0,0,2~2,0,2
      0,2,3~2,2,3
      0,0,4~0,2,4
      2,0,5~2,2,5
      0,1,6~2,1,6
      1,1,8~1,1,9
    IN

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 5, part_one_answer(@file)
  end

  def test_part_two
    assert_equal 7, part_two_answer(@file)
  end
end
