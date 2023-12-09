#
# create day's folder structure
# cmd example: ruby gen.rb 21
#

day = ARGV[0]
dir_name = "day#{day}"

day_data = <<~TEMPLATE
  ###
  ### Aoc 2023. Day #{day}
  ###

  def part_one_answer
  end

  def part_two_answer
  end
TEMPLATE

test_data = <<~TEMPLATE
  require "minitest/autorun"
  require_relative "main"

  class Day#{day}Test < Minitest::Test
    def setup
      @file = "example.txt"

      data = ""

      File.write(@file, data)
    end

    def teardown
      File.delete(@file) if File.exist?(@file)
    end

    def test_part_one
      skip
      assert_equal 0, part_one_answer(@file)
    end

    def test_part_two
      skip
      assert_equal 0, part_two_answer(@file)
    end
  end
TEMPLATE

unless File.exist?(dir_name)
  Dir.mkdir(dir_name)
  Dir.chdir(dir_name)

  File.write("input.txt", "")
  File.write("main.rb", day_data)
  File.write("main_test.rb", test_data)

  puts "Done"
end
