#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________

template caddr   *(s :cstring)    :cstringArray=   cast[cstringArray](s.unsafeAddr)
template caddr   *(n :int32)      :ptr int32=      n.unsafeaddr
template caddr   *(n :float32)    :ptr float32=    n.unsafeaddr

