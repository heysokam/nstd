#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________

template caddr    *(s :cstring)      :cstringArray=  cast[cstringArray](s.unsafeAddr)
template caddr    *(n :int32)        :ptr int32=     n.unsafeaddr
template caddr    *(n :uint32)       :ptr uint32=    n.unsafeaddr
template caddr    *(n :float32)      :ptr float32=   n.unsafeaddr
template caddr *[T](a :openArray[T]) :ptr T=         a[0].unsafeaddr

