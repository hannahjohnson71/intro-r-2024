#### R Basics ####
# "A foolish consistency is the hobgoblin of 
#   little minds"   -Ralph Waldo Emerson 

# Literals ----
"this is a string literal" # double quotes preferred in R but not required
42
T
F
TRUE
FALSE

# Operators ----
  # Arithmetic
2 + 3 # note the spacing
2+3 # hard to read, difficult for future review
2 - 3
2 * 3 # multiplication
2 ** 3 # 2 to the 3rd
2 ^ 3 # better way to use an exponent
2 / 3 # division

  # Comparison
2 == 2 # tests for equality
"Joe" == "joe" # case-sensitivity
"Joe" == 'Joe' # not quotation-sensitive
# try to use double-quotes in R , as single quote can be mistaken for back-tick
2 == 1 + 1 # OK
2 == (1 + 1) # better

2 != 1 # tests inequality

2 < 3
2 > 3
2 <= 2
2 >= 3

# somewhat of a cruel joke
TRUE == 1 # Boolean value of true is 1
isTRUE(TRUE == 1)
FALSE == 0 # Boolean value of true is 0
isTRUE(FALSE == 0)

isTRUE(TRUE) # function testing if the argument is literally TRUE
isTRUE(1) # function testing if the argument is literally TRUE
?isTRUE # queries built-in help

2 < 3 & 2 > 3 # both have to pass to return TRUE
2 < 3 | 2 > 3 # either can be TRUE to return TRUE
2 < 3 & (2 == 1 | 2 ==2) # grouping logic to test multiple conditions

# type matters (sometimes)
"joe" # string or character type
typeof("joe")
42 # numeric type (double precision, floating point)
typeof(42)
TRUE # logical or Boolean type
typeof(TRUE)

42 == "42" # this is TRUE, b/c equality can cross types
identical(42, "42") # type matters for identity

# variables ----


# data structures ----
# vectors have a single dimension, like a column or row of data

# data frames - the key structure for data science, multi-dimensional
#   collections of vectors


# Special type: factors, and putting it all together ----
# factors are categorical variables with a fixed set of
#   potential values


