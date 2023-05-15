#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
# std dependencies
import std/os

const echod * = debugEcho
  ## Short Alias for debugEcho

proc wait *(sec :int) :void=  sleep(sec*1000)
  ## Waits for the given number of seconds.
  ## Alias for std/os.sleep

func alignTo *[T :SomeInteger|SomeUnsignedInt](num, to :T) :T=
  ## Aligns the given `num` to the given number `to`, which must be a power of 2.
  # Explanation:
  # `to` being a power of two guarantees that it has only one bit active.
  # (align-1)   will make all the bits below it active. Adding this to the number means:
  #   : if number is already aligned, it will fill out the bits below alignment
  #   : if its not aligned, it will move it over the next align boundary and maybe some inactive bits will be activated.
  # ~(align-1)  will invert the bits, creating a mask that can be used to cut off bits below alignment. 
  # &           will mask out the lower bits aligning the result
  assert (to > 1) and (to and (to-1)) == 0, "The number to align to must be a power of 2"
  result = (num + to-1) and not(to-1)

func alignTo4 *[T :SomeInteger](num :T) :T=  num.alignTo(4)
  ## Aligns the given `num` to be a multiple of 4.

