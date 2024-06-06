#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
## @fileoverview Extensions for `std/sets`
import std/sets as stdSets ; export stdSets


#_______________________________________
# @section Union Operations
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
func `+=` *[T](A :var HashSet[T]; B :HashSet[T]) :void= A = A+B


#_______________________________________
# @section Iterators
#_____________________________
iterator pairs *[T](A :HashSet[T]) :tuple[id:int, value:T]=
  var count = 0
  for entry in A:
    yield (id: count, value: entry)
    count.inc


#_______________________________________
# @section set[T] Tools
#_____________________________
func hasAny *[T](A,B :set[T]) :bool=
  ## @descr Returns true if any of the elements of {@arg A} is contained in {@arg B}
  for a in A:
    if a in B: return true
#___________________
func hasAll *[T](A,B :set[T]) :bool=
  ## @descr Returns true if all of the elements of {@arg B} are contained in {@arg A}
  for b in B:
    if b notin A: return false
  return true
#___________________
func allIn *[T](A,B :set[T]) :bool=  B.hasAll(A)
  ## @descr Returns true if all of the elements of {@arg A} are contained in {@arg B}. Same as {@link hasAll} with reverse arguments order
#___________________
func disjoint *[T](A,B :set[T]) :bool=
  ## @descr Returns true if none of the elements of {@arg A} is contained in {@arg B}
  for a in A:
    if a in B: return false
  return true
#___________________
func with *[T](A :set[T]; B :T) :set[T]=  result = A; result.incl B
func without *[T](A :set[T]; B :T) :set[T]=
  result = A
  if B in A: result.excl B

