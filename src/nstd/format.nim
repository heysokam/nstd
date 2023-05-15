#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________

#____________________
type LineSeparator * = enum bStart, bEnd, cStart, cEnd, genericSep  # b = block ; c = category
#____________________
template blockStart *() :string=  "____________________"
template blockEnd   *() :string=  "____________________"
template catStart   *() :string=  ":: _________________"
template catEnd     *() :string=  ":: _______________::"
#____________________
proc lineSep *(sep :LineSeparator) :void= 
  case sep
  of   bStart:     echo blockStart()
  of   bEnd:       echo blockEnd()
  of   cStart:     echo catStart()
  of   cEnd:       echo catEnd()
  of   genericSep: echo blockStart()
#____________________
proc lineSep *() :void= lineSep(genericSep)
#____________________


#____________________
proc reprb *[T](n :var T) :string=  cast[ByteAddress](n.addr).repr
  ## Returns the string representation of an address.
proc repra *[T](n :var T) :string=  n.addr.repr & " " & n.reprb
  ## Returns the string representation of an address.
  ## Same as reprb, with better formatting

