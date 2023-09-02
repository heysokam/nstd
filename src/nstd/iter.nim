#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/sets


#_____________________________
iterator twoD *[T](data :var openarray[T]; width, height :int) :var T=
  ## Iterate through a Linear 2D array, and yield each item as modifiable (like mitems)
  for row in 0..<height:
    for col in 0..<width:
      yield data[row*width+col]

#_____________________________
iterator backwards *[T](arr :openArray[T]) :T=
  ## Iterates through the given array from end to start.
  ## Inverse of `arr.items`
  for id in countdown(arr.high, arr,low): yield arr[id]
#___________________
iterator mbackwards *[T](arr :var openArray[T]) :var T=
  ## Iterates through the given array from end to start.
  ## Inverse of `arr.mitems`
  for id in countdown(arr.high, arr,low): yield arr[id]
#_____________________________
iterator backwards *[T](arr :SomeSet[T]) :T=
  ## Iterates through the given set from end to start.
  ## Inverse of `arr.items`
  for id in countdown(arr.high, arr,low): yield arr[id]

