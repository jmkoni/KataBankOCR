# @author Jennifer Konikowski <jmkoni@icloud.com>
# This class takes a file that contains a list of numbers written with pipes
# and underscores (think a calculator display) and returns a list of real
# numbers. Each entry is 4 lines long, and each line has 27 characters. The
# first 3 lines of each entry contain an account number written using pipes
# and underscores, and the fourth line is blank. Each account number should
# have 9 digits, all of which should be in the range 0-9. 
# 
# From: [KataBankOCR](http://codingdojo.org/kata/BankOCR/)
# 
# Initialization:
#     reader = PipeNumber::Reader.new(filepath)
# 
# Definition of parameters:
#     filepath:          path to file containing text numbers
# 
# Note:
#     File should look like this:
#     _  _  _  _  _  _  _  _  _ 
#     _|| || || || || || || || |
#    |_ |_||_||_||_||_||_||_||_|
# 
#     _  _  _  _  _  _  _  _  _ 
#     _| _| _| _| _| _| _| _| _|
#     _| _| _| _| _| _| _| _| _|
# 
#     _     _  _  _  _  _  _  _ 
#     _||_||_ |_||_| _||_||_ |_ 
#     _|  | _||_||_||_ |_||_| _|
class PipeNumber
  # This class takes in an array of characters (each three characters long)
  # and translates it into a single number or ? if the number is not found.
  # Initialization:
  #     translated_number = Translator.new(number_array)
  class Translator
    # Gets the translated number
    # @return [String] number
    attr_reader :num
    
    # Initalizes new Translator object
    # @param number_array [Array] array of length 3, strings, doesn't change after initialization
    # @return [Translator] a new Translator object
    # @example Create a new Translator (for number 3)
    #     Translator.new([" _ ", " _|", " _|"])
    def initialize(number_array)
      if number_array
        @num = determine_number(number_array[0], number_array[1], number_array[2])
      else
        @num = ""
      end
    end

    private
    # NOT THE BEST WAY I AM PRETTY SURE
    # so many if statements :(
    def determine_number(row1, row2, row3)
      if row1 == " _ "
        num = row_one_underscore(row2, row3)
      elsif row1 == "   "
        num = row_one_empty(row2, row3)
      else
        num = "?"
      end
      num
    end

    def row_one_empty(row2, row3)
      if row2 == "  |"
        if row3 == "  |"
          num = "1"
        else
          num = "?"
        end
      elsif row2 == "|_|"
        if row3 == "  |"
          num = "4"
        else
          num = "?"
        end
      else
        num = "?"
      end
      num
    end

    def row_one_underscore(row2, row3)
      if row2 == "| |"
        if row3 == "|_|"
          num = "0"
        else
          num = "?"
        end
      elsif row2 == "|_ "
        num = row_two_left(row3)
      elsif row2 == "|_|"
        num = row_two_both(row3)
      elsif row2 == " _|"
        num = row_two_right(row3)
      elsif row2 == "  |"
        if row3 == "  |"
          num = "7"
        else
          num = "?"
        end
      else
        num = "?"
      end
      num
    end

    def row_two_left(row3)
      if row3 == " _|"
        num = "5"
      elsif row3 == "|_|"
        num = "6"
      else
        num = "?"
      end
      num
    end

    def row_two_both(row3)
      if row3 == "|_|"
        num = "8"
      elsif row3 == " _|"
        num = "9"
      else
        num = "?"
      end
      num
    end

    def row_two_right(row3)
      if row3 == "|_ "
        num = "2"
      elsif row3 == " _|"
        num = "3"
      else
        num = "?"
      end
      num
    end
  end
  
  # This class takes in a filepath, splits it into lines, and send to the
  # translator.
  # Initialization:
  #     number = Reader.new(file_path)
  class Reader
    # Gets the list of translated numbers
    # @return [Array] list of numbers (strings)
    attr_reader :numbers
    
    # Initalizes new Reader object
    # @param file_path [String] path to file containing numbers
    # @return [Reader] a new Reader object
    # @example Create a new Reader
    #     Reader.new("~/Desktop/numbers.txt")
    def initialize(file_path)
      @file = File.open(file_path, "r")
      @count = (%x{wc -l #{file_path}}.split.first.to_i / 4) + 1
      @numbers = number_reader
    end

    private
    # should look like this:
    #   [ [[row1, row2, row3] x 9] x count ]
    def number_reader
      numbers = Array.new(@count) { Array.new(9) { Array.new(3) { "   " }} }
      index = 0
      number_chars = []
      @file.each_line do |line|
        # ignore every fourth line (blank line)
        if index % 4 == 3
          index += 1
          next
        end
        number_chars << line.scan(/.{1,3}/)
        index += 1
      end

      number_chars.each_with_index do |characters, i|
        next if characters.length == 0
        characters.each_with_index do |character, j|
          numbers[i / 3][j][i%3] = character
        end
      end
      translate_numbers(numbers)
    end

    def translate_numbers(numbers)
      translated_numbers = []
      numbers.each do | all_numbers |
        number = ""
        all_numbers.each do | indiv_number |
          number += Translator.new(indiv_number).num
        end
        if number.include?("?")
          number = number + " ILL"
        else
          unless is_valid_checksum(number)
            number = number + " ERR"
          end
        end
        translated_numbers << number
      end
      translated_numbers
    end
    
    def is_valid_checksum(number)
      sum = 0
      number_length = number.length
      number.split("").each_with_index do | character, i |
        sum += character.to_i * (number_length - i)
      end
      sum % 11 == 0
    end
  end
end

puts "Please enter the filename:"
filename = gets.chomp
reader = PipeNumber::Reader.new(filename)
reader.numbers.each do |num|
  puts num
end
