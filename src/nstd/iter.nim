#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________


#_____________________________
iterator twoD *[T](data :var openarray[T]; width, height :int) :var T=
  ## Iterate through a Linear 2D array, and yield each item as modifiable (like mitems)
  for row in 0..<height:
    for col in 0..<width:
      yield data[row*width+col]

