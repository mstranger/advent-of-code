require "minitest/autorun"
require_relative "main"

class Day25Test < Minitest::Test
  def setup
    @file = "example.txt"

    data = <<~INPUT
      jqt: rhn xhk nvd
      rsh: frs pzl lsr
      xhk: hfx
      cmg: qnr nvd lhk bvb
      rhn: xhk bvb hfx
      bvb: xhk hfx
      pzl: lsr hfx nvd
      qnr: nvd
      ntq: jqt hfx bvb xhk
      nvd: lhk
      lsr: lhk
      rzs: qnr cmg lsr rsh
      frs: qnr lhk lsr
    INPUT

    File.write(@file, data)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_part_one
    assert_equal 54, part_one_answer(@file)
  end

  def test_part_two
    skip
    assert_equal 0, part_two_answer(@file)
  end
end
