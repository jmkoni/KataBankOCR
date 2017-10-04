# KataBankOCR

This is an attempt to solve the KataBankOCR problem, user stories 1 through 3.


View original problem at: http://codingdojo.org/kata/BankOCR/

View full docs at: https://jmkoni.github.io/KataBankOCR/

View source code at: https://github.com/jmkoni/KataBankOCR

#### Initialization:
```ruby
PipeNumber::Reader.new(filepath)
```
#### Definition of parameters:

* filepath: path to file containing text numbers

#### Example:

Of running the class:
```ruby
# numbers.txt looks like this:
#     _  _     _  _  _  _  _ 
#   | _| _||_||_ |_   ||_||_|
#   ||_  _|  | _||_|  ||_| _|
# 
#  _  _  _  _  _  _  _  _    
# | || || || || || || ||_   |
# |_||_||_||_||_||_||_| _|  |
# 
#     _  _  _  _  _  _     _ 
# |_||_|| || ||_   |  |  | _ 
#   | _||_||_||_|  |  |  | _|
  
reader = PipeNumber::Reader.new("~/Desktop/numbers.txt")
reader.print_all_with_variations
```

Of running the script:
```ruby
ruby read_numbers.rb
# it will then prompt you for a file path. Please type it in, then press enter.
```

#### Output:
```
123456789
000000051
49006771? ILL
```
