#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# External dependencies
import pkg/chroma

template caddr *(c :var Color) :ptr float32=  c.r.addr

