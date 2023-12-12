require "minitest/autorun"
require_relative "main"

class Day12Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~INPUT
      ???.### 1,1,3
      .??..??...?##. 1,1,3
      ?#?#?#?#?#?#?#? 1,3,1,6
      ????.#...#... 4,1,1
      ????.######..#####. 1,6,5
      ?###???????? 3,2,1
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 21, part_one_answer(@file)
  end

  def test_part_two
    skip
    assert_equal 0, part_two_answer(@file)
  end
end
