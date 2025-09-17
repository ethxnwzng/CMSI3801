local exercises = require("exercises")

--find_first function
print("=== Testing find_first ===")

-- Test with numbers
local numbers = {1, 3, 5, 7, 9, 11}
local is_even = function(x) return x % 2 == 0 end
local is_odd = function(x) return x % 2 == 1 end
local is_greater_than_10 = function(x) return x > 10 end

print("First even number:", exercises.find_first(numbers, is_even)) -- should be nil
print("First odd number:", exercises.find_first(numbers, is_odd)) -- should be 1
print("First number > 10:", exercises.find_first(numbers, is_greater_than_10)) -- should be 11

--test with strings
local words = {"hello", "world", "test", "example"}
local starts_with_t = function(word) return word:sub(1,1) == "t" end
local has_five_chars = function(word) return #word == 5 end

print("First word starting with 't':", exercises.find_first(words, starts_with_t)) -- should be "test"
print("First word with 5 chars:", exercises.find_first(words, has_five_chars)) -- should be "hello"

--test with empty sequence
print("First in empty sequence:", exercises.find_first({}, is_even)) -- should be nil

print()

--powers_generator function
print("=== Testing powers_generator ===")

--test powers of 2 up to 16
local gen2 = exercises.powers_generator(2, 16)
print("Powers of 2 up to 16:")
local result = gen2()
while result do
    print(result)
    result = gen2()
end

--test powers of 3 up to 27
local gen3 = exercises.powers_generator(3, 27)
print("Powers of 3 up to 27:")
result = gen3()
while result do
    print(result)
    result = gen3()
end

--test powers of 5 up to 25
local gen5 = exercises.powers_generator(5, 25)
print("Powers of 5 up to 25:")
result = gen5()
while result do
    print(result)
    result = gen5()
end

print()

--count_lines function
print("=== Testing count_lines ===")

--create a test file
local test_file = io.open("test_file.txt", "w")
test_file:write("This is line 1\n")
test_file:write("This is line 2\n")
test_file:write("\n")  -- empty line
test_file:write("   \n")  -- whitespace only line
test_file:write("# This is a comment\n")
test_file:write("This is line 3\n")
test_file:write("  # This is also a comment\n")
test_file:write("This is line 4\n")
test_file:write("")  -- empty line at end
test_file:close()

print("Lines in test_file.txt:", exercises.count_lines("test_file.txt")) -- should be 4

--test with non-existent file
print("Lines in non_existent.txt:", exercises.count_lines("non_existent.txt")) -- should be 0

print()

--say function
print("=== Testing say function ===")

--test chaining with words
local result1 = exercises.say("Hello")("my")("name")("is")("Colette")()
print("Chained result:", result1) -- should be "Hello my name is Colette"

--test with single word
local result2 = exercises.say("Hello")()
print("Single word:", result2) -- should be "Hello"

--test with no words
local result3 = exercises.say()()
print("No words:", result3) -- should be ""

--test with numbers
local result4 = exercises.say("1")("2")("3")("4")("5")()
print("Numbers:", result4) -- should be "1 2 3 4 5"

--test mixed types
local result5 = exercises.say("The")("answer")("is")("42")()
print("Mixed:", result5) -- should be "The answer is 42"

print()
print("All tests completed!")