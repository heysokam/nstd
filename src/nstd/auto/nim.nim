#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________

# converter toBool *(n :SomeInteger) :bool=  n != 0
#  ## Autoconverts ints to true/false in python/C style. 0 = false, 1 = true
#  ## Breaks a lot of code, because of nimc not knowing how to deal with uint and bool.

converter toBool *(s :string)  :bool=  s.len != 0
  ## Converts a string to bool, in python style. True when the string is not "".

