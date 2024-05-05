#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Extensions for `std/sets`
import std/sets ; export sets


#_______________________________________
# @descr Union Operations
#_____________________________
func `+` *[T](A,B :OrderedSet[T]) :OrderedSet[T]=
  ## @descr
  ##  Union operation for two OrderedSets.
  ##  Adds everything from A to the result first, and appends whatever is missing from {@arg B} at the end
  ## @note Could be argued that there is more than one way to order the result. This is just the simplest version.
  for a in A: result.incl a
  for b in B: result.incl b

