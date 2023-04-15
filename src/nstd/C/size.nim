#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________

template csizeof *[T](arr :openArray[T]) :cint=  (arr[0].sizeof * arr.len).cint
  ## Returns the size of the array/seq in bytes, as a cint.

