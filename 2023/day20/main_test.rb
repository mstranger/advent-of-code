require "minitest/autorun"
require_relative "main"

class Day20Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~INPUT
      broadcaster -> a, b, c
      %a -> b
      %b -> c
      %c -> inv
      &inv -> a
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 32000000, part_one_answer(@file)
  end

  def test_part_two
    skip
    assert_equal 0, part_two_answer(@file)
  end
end
