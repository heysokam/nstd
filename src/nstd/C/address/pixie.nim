#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________
# External dependencies
import pkg/pixie

template caddr *(i :Image) :ptr ColorRGBX=  i.data[0].addr
