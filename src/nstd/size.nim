#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/strformat


#_______________________________________
# Size Calculation
#___________________
func toBytes *(n :SomeInteger) :uint32=  assert (n mod 8) == 0; result = uint32( n div 8 )
  ## Returns the given multiple of 8 divided by 8 (eg: 8bits == 1byte)
#_____________________________
func size *[T](t :typedesc[T]) :uint64=  uint64( sizeof(t) )
  ## Returns the size in bytes of the given type. Alias for sizeof()
func size *[T :not openArray](n :T) :uint64=  uint64( sizeof(n) )
  ## Returns the size in bytes of the given type. Alias for sizeof()
func size *[T :not openArray](v :openArray[T]) :uint64=  uint64( v.len * sizeof(v[0]) )
  ## Returns the size in bytes of the given seq
#_____________________________
template csizeof *[T](arr :openArray[T]) :cint=  (arr[0].sizeof * arr.len).cint
  ## Returns the size of the array/seq in bytes, as a cint.


#_______________________________________
# Alignment
#___________________
func alignTo *[T :SomeInteger|SomeUnsignedInt](num, to :T) :T=
  ## Aligns the given `num` to the given number `to`, which must be a power of 2.
  # Explanation:
  # `to` being a power of two guarantees that it has only one bit active.
  # (align-1)   will make all the bits below it active. Adding this to the number means:
  #   : if number is already aligned, it will fill out the bits below alignment
  #   : if its not aligned, it will move it over the next align boundary and maybe some inactive bits will be activated.
  # ~(align-1)  will invert the bits, creating a mask that can be used to cut off bits below alignment. 
  # &           will mask out the lower bits aligning the result
  assert (to > 1) and (to and (to-1)) == 0, &"Called for alignTo( {num}, {to} ), but the number to align to must be a power of 2"
  result = (num + to-1) and not(to-1)
#_____________________________
func alignTo *[T1 :SomeInteger, T2](num :T1; t :typedesc[T2]) :T1=  num.alignTo(sizeof(T2)*8)
  ## Aligns the given `num` to be a multiple of the size of the given type.
func alignTo4 *[T :SomeInteger](num :T) :T=  num.alignTo(4)
  ## Aligns the given `num` to be a multiple of 4.
func alignTo8 *[T :SomeInteger](num :T) :T=  num.alignTo(8)
  ## Aligns the given `num` to be a multiple of 8 (aka the size of a byte).

