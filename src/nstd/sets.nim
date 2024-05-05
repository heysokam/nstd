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
#___________________
func `+=` *[T](A :var OrderedSet[T]; B :OrderedSet[T]) :void= A = A+B
#___________________
iterator pairs *[T](A :HashSet[T]) :tuple[id:int, value:T]=
  var count = 0
  for entry in A:
    yield (id: count, value: entry)
    count.inc

