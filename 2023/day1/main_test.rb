require "minitest/autorun"
require_relative "main"

class Day1Test < Minitest::Test
  def setup
    @file = "example.txt"
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_first_part
    data =<<~INPUT
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
    INPUT

    File.write(@file, data)
    assert_equal 142, answer(@file)
  end

  def test_second_part
    data =<<~INPUT
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
    INPUT

    File.write(@file, data)
    assert_equal 281, answer(@file)
  end
end
