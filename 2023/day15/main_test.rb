require "minitest/autorun"
require_relative "main"

class Day15Test < Minitest::Test
  def setup
    @file = "example.txt"
    data = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7\n"
    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 1320, part_one_answer(@file)
  end

  def test_part_two
    assert_equal 145, part_two_answer(@file)
  end
end
