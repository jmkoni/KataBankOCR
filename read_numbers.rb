require 'text'

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
    # I do think this isn't a bad way to start user story 4 though...
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
  
  # This class should get all manipulations of any given character set.
  # Initialization:
  #     variants = Variant.new(number_array)  
  class Variant
    # Gets the original array of characters
    # @return [Array] original array of characters
    attr_reader :original_array
    
    CHARACTERS = ["|", "_", " "]
    VALID_PATTERNS = [" _ ", "   ", "|  ", "  |", "|_ ", " _|", "|_|"]
    
    # Initalizes new Variant object
    # @param number_array [Array] array of length 3, strings, doesn't change after initialization
    # @return [Variant] a new Variant object
    # @example Create a new Variant (for number 3)
    #     Variant.new([" _ ", " _|", " _|"])
    def initialize(number_array)
      @original_array = number_array
    end
    
    # Returns all variations for a Variant object
    # @return [Array] an array of string numbers
    # @example Get all variations for a Variant
    #     variant.number_variations
    def number_variations
      all_numbers = []
      variations.each do | variant |
        num = Translator.new(variant).num
        all_numbers << num unless num == "?"
      end
      all_numbers
    end
    
    private
    def variations
      all_variations = []
      @original_array.each_with_index do |characters, i|
        VALID_PATTERNS.each do |pattern|
          if Text::Levenshtein.distance(characters, pattern) == 1
            tmp_array = @original_array.dup
            tmp_array[i] = pattern
            all_variations << tmp_array
          end
        end
      end
      all_variations
    end
  end

  # This class represents an account number, with variants.
  # Initialization:
  #     account_number = AccountNumber.new(number, variants)  
  class AccountNumber
    # Gets the number
    # @return [String] 9 digit account number
    attr_reader :value
    # Gets the list of variants
    # @return [Array] list of variants
    attr_reader :variants
    # Gets the error
    # @return [String] either "ERR", "ILL", or nil
    attr_reader :error
    
    # Initalizes new AccountNumber object
    # @param number [Array] array of Translator objects
    # @param variants [Array] array of Variant objects
    # @return [AccountNumber] a new AccountNumber object
    # @example Create a new AccountNumber
    #     Reader.new([], [])
    def initialize(number, variants)
      @variants = []
      @value = determine_number(number, variants)
      @error = AccountNumber.validate(@value)  
    end
    
    # Validates a given account number
    # @param number [String] 9 digit account number
    # @return [String] either "ERR", "ILL", or nil
    # @example Validate an account number
    #     AccountNumber.validate("123567")
    def self.validate(number)
      check_error(number)
    end
    
    # Validates variants
    # @example Validate the variants
    #     account_number.validate_variants
    def validate_variants
      @variants.select! do | variant |
        variant_error = AccountNumber.validate(variant)
        variant_error.nil?
      end
      if error_exists? and @variants.any?
        @value = @variants.shift
        @error = AccountNumber.validate(@value)
      end      
    end
    
    private
    def error_exists?
      !@error.nil?
    end
    
    def determine_number(number, variants)
      main_number = ""
      full_variants = []
      number.each_with_index do |num, i|
        old_number = main_number
        main_number += num.num
        full_variants = update_full_variants(full_variants, num.num, variants[i], old_number)  
      end
      @variants = full_variants.select { | variant | variant.length == 9 }
      main_number
    end
    
    def update_full_variants(full_variants, number, variant, old_number)
      variant_nums = variant.number_variations
      if number == "?"
        variant_nums.each do | variant_num |
          full_variants.map! do | full_variant |
            full_variant += variant_num
          end
        end
      else
        full_variants.map! do | full_variant |
          full_variant += number
        end
      end
      
      unless variant_nums.empty?
        variant_nums.each do | variant_num |
          full_variants << old_number + variant_num
        end
      end
      full_variants
    end
    
    def self.check_error(number)
      if number.include?("?")
        "ILL"
      elsif !is_valid_checksum(number)
        "ERR"
      else
        nil
      end
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
    
    # Prints all numbers
    # @example Prints all numbers
    #     reader.print_all
    def print_all
      numbers.each do | num |
        if num.error
          puts num.value + " " + num.error
        else
          puts num.value
        end
      end
    end
    
    # Prints all numbers with variations
    # @example Prints all numbers with the variations
    #     reader.print_all_with_variations
    def print_all_with_variations
      numbers.each do | num |
        # puts "num: " + numm.value
        num.validate_variants
        if num.error
          puts num.value + " " + num.error
        elsif num.variants.any?
          puts num.value + " AMB " + num.variants.inspect
        else
          puts num.value
        end
      end
    end

    private
    # should look like this:
    #   [ [[row1, row2, row3] x 9] x count ]
    # read in the file and organize it into individual "numbers"
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
          numbers[i / 3][j][i % 3] = character
        end
      end
      translate_numbers(numbers)
    end
    
    # take each set of string numbers and translate them into an actual number
    def translate_numbers(numbers)
      translated_numbers = []
      numbers.each do | all_numbers |
        number = []
        variants = []
        all_numbers.each do | indiv_number |
          number << Translator.new(indiv_number)
          variants << Variant.new(indiv_number)
        end
        
        translated_numbers << AccountNumber.new(number, variants)
      end
      translated_numbers
    end
    
  end
end

puts "Please enter the file path:"
filename = gets.chomp
reader = PipeNumber::Reader.new(filename)
reader.print_all_with_variations
