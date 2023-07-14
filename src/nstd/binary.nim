#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
# std dependencies
import std/strformat
import std/typetraits
# nstd dependencies
import ./defines as def


#_____________________________________________________
# treeform/binny readT as generics
#_____________________________
when not def.NimScript:
  func read *[T :not ptr](buf :string; _:typedesc[T]; pos :SomeInteger) :T {.inline.}=
    ## Reads a T type from a string bytebuffer at `pos` id.
    when not T.supportsCopyMem:  raise newException(IOError, &"Tried to read from a bytebuffer, but {$T} does not support copyMem.")
    copyMem(result.addr, buf[pos].addr, sizeof(T))
#_____________________________
func read *(buf :string; _:typedesc[string]; startp,endp :SomeInteger) :string {.inline.}=
  ## Reads a string from a string bytebuffer, from `startp` to `endp` positions.
  buf[startp ..< min(s.len, startp+endp)]

