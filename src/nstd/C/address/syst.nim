#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________

#___________________
template caddr    *(s :cstring)      :cstringArray=  cast[cstringArray](s.unsafeAddr)
template caddr    *(n :int32)        :ptr int32=     n.unsafeaddr
template caddr    *(n :uint32)       :ptr uint32=    n.unsafeaddr
template caddr    *(n :float32)      :ptr float32=   n.unsafeaddr
template caddr *[T](a :openArray[T]) :ptr T=         a[0].unsafeaddr

#___________________
template vaddr *(val :auto) :untyped=
  ## Returns the `addr` of anything, through a temp val.
  ## Useful when the objects have not been created yet.
  let temp = val; temp.unsafeAddr
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

