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
x <- "this is a string" # in R, read as assigning the string to variable x
x
typeof(x) # character
x <- 10
x
x ^ 2 # always refers to the assigned value

x <- 'pizza'
pizza <- 'x' # variable names can be most anything
pizza

# my var <- 42 # makes an error
my_var <- 42 # that's better
my_var = 42 # works, but people don't write in R this way
my_var
x <- my_var # helps reader follow assignment direction
x


# data structures ----
# vectors have a single dimension, like a column or row of data
a <- c("1", "2", "3") #c() stands for collect what's inside
a
a <- c(1, 2, 3)
a
a + 1 # (returns 2 3 4)

a <- c(1, 2, 3, "4")
a
typeof(a) # R will assign vector type to make them all work
a + 1 # results in an error

a <- c(1, 2, 3)
a < 3
any(a < 3) # tests whether any comparison is TRUE
all(a < 3) # tests whether all comparisons are TRUE

3 %in% a # tests membership in a vector
4 %not in% a # not a function
!4 %in% a # ! works as a negation

# data frames - the key structure for data science, multidimensional
#   collections of vectors

df <- data.frame(a = c(1, 2, 3),
                 b = c("joe", "tammy", "matt")) # collection of vectors
df
df$a # references a single column
df$b

"joe" %in% df$b

df$mode <- c("bike", "car", "bus") #adding a column
df

summary(df) # summarizes by column

# Special type: factors, and putting it all together ----
# factors are categorical variables with a fixed set of
#   potential values


