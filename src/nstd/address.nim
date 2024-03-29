#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________


#_______________________________________
# Variable
#_____________________________
template mvar *(t: typed) :untyped=
  ## Returns a (mutable) variable for the input `t`.
  ## Useful for passing tuples as `:var tuple`, without requiring the extra variable step.
  var mutName = t; mutName

#_______________________________________
# System
#___________________
template caddr    *(s :cstring)      :cstringArray=  cast[cstringArray](s.addr)
template caddr    *(n :int32)        :ptr int32=     n.addr
template caddr    *(n :uint32)       :ptr uint32=    n.addr
template caddr    *(n :float32)      :ptr float32=   n.addr
template caddr *[T](a :openArray[T]) :ptr T=         a[0].addr
#___________________
template vaddr *(val :auto) :untyped=
  ## Returns the `addr` of anything, through a temp val.
  ## Useful when the objects have not been created yet.
  let temp = val; temp.addr
#___________________
template iaddr *[T](num :SomeUnsignedInt) :ptr T=
  ## Returns the SignedInt `addr` of an UnsignedInt.
  ## Useful for C interop. Equivalent to `(int*)&someUint`
  when T isnot SomeSignedInt: {.fatal: "iaddr can only be used to get SignedInt addresses".}
  cast[ptr T](num.addr)
#___________________
template iaddr *(num :uint32) :ptr int32=  cast[ptr int32](num.addr)
  ## Explicit instantiation of iaddr[T] for uint32-to-int32.
  ## Returns the int32 `addr` of an uint32.
  ## Useful for C interop. Equivalent to `(int32_t*)&someUint32`

