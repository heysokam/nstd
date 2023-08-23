#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________


#_______________________________________
# cint
#___________________
converter toCint *(cond :bool) :cint=  result = if cond: 1.cint else: 0.cint
  ## Converts the bool to cint. True will be 1, false will be 0.

#_______________________________________
# bool
#___________________
converter toBool *(s :string)  :bool=  s.len != 0
  ## Converts a string to bool, in python style. True when the string is not "".
#___________________
# converter toBool *(n :SomeInteger) :bool=  n != 0
#  ## Autoconverts ints to true/false in python/C style. 0 = false, 1 = true
#  ## Breaks a lot of code, because of nimc not knowing how to deal with uint and bool.

