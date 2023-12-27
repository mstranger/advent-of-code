require "minitest/autorun"
require_relative "main"

class Day10Test < Minitest::Test
  def setup
    @file = "example.txt"

    @data = <<~INPUT
      ..F7.
      .FJ|.
      SJ.L7
      |F--J
      LJ...
    INPUT

    File.write(@file, @data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 8, part_one_answer(@file)
  end

  def test_part_two
    @data = <<~INPUT
      .F----7F7F7F7F-7....
      .|F--7||||||||FJ....
      .||.FJ||||||||L7....
      FJL7L7LJLJ||LJ.L-7..
      L--J.L7...LJS7F-7L7.
      ....F-J..F7FJ|L7L7L7
      ....L7.F7||L7|.L7L7|
      .....|FJLJ|FJ|F7|.LJ
      ....FJL-7.||.||||...
      ....L---J.LJ.LJLJ...
    INPUT
    File.write(@file, @data)

    assert_equal 8, part_two_answer(@file)
  end
end
