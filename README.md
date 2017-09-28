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
reader.numbers.each do |num|
  puts num
end
```

#### Output:
```
123456789
000000051
49006771? ILL
```
