#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________

proc `new` *[T](x :T) :ref T=
  ## Creates a new ref T from the given value
  ## Alias for:
  ##   val   = new(T)
  ##   val[] = thing
  new result
  result[] = x

