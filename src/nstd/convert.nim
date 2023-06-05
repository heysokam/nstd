#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________


#___________________
proc toVersU8 *(tup :tuple[major, minor :int]) :tuple[major, minor :uint8]=  (tup.major.uint8, tup.minor.uint8)
  ## Converts a (major, minor) int tuple into a (uint8, uint8) one

#___________________
proc toString *(oa :openarray[char]) :string=
  ## Converts an array/seq of chars into a string
  result = newStringOfCap(oa.high)
  for ch in oa:
    if ch == '\0': break
    result.add ch

#___________________
proc toCStringArray *(oa :openarray[string]) :cstringArray=  oa.allocCstringArray
  ## Converts an array/seq of strings into a cstringArray

