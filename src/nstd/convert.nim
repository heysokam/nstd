#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________


#___________________
proc toString *(oa :openarray[char]) :string=
  ## @descr Converts an array/seq of chars into a string
  result = newStringOfCap(oa.high)
  for ch in oa:
    if ch == '\0': break
    result.add ch
