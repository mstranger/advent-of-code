require "minitest/autorun"
require_relative "main"

class Day17Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~INPUT
      2413432311323
      3215453535623
      3255245654254
      3446585845452
      4546657867536
      1438598798454
      4457876987766
      3637877979653
      4654967986887
      4564679986453
      1224686865563
      2546548887735
      4322674655533
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 102, part_one_answer(@file)
  end

  def test_part_two
    assert_equal 94, part_two_answer(@file)
  end

  def test_part_two_second_example
    data = <<~INPUT
      111111111111
      999999999991
      999999999991
      999999999991
      999999999991
    INPUT

    File.write(@file, data)
    assert_equal 71, part_two_answer(@file)
  end
end
