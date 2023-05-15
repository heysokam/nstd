#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
# External dependencies
import pkg/chroma

template caddr *(c :var Color) :ptr float32=  c.r.addr

