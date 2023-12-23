require "minitest/autorun"
require_relative "main"

class Day23Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~INPUT
      #.#####################
      #.......#########...###
      #######.#########.#.###
      ###.....#.>.>.###.#.###
      ###v#####.#v#.###.#.###
      ###.>...#.#.#.....#...#
      ###v###.#.#.#########.#
      ###...#.#.#.......#...#
      #####.#.#.#######.#.###
      #.....#.#.#.......#...#
      #.#####.#.#.#########v#
      #.#...#...#...###...>.#
      #.#.#v#######v###.###v#
      #...#.>.#...>.>.#.###.#
      #####v#.#.###v#.#.###.#
      #.....#...#...#.#.#...#
      #.#########.###.#.#.###
      #...###...#...#...#.###
      ###.###.#.###v#####v###
      #...#...#.#.>.>.#.>.###
      #.###.###.#.###.#.#v###
      #.....###...###...#...#
      #####################.#
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 94, part_one_answer(@file)
  end

  def test_part_two
    skip
    assert_equal 0, part_two_answer(@file)
  end
end
