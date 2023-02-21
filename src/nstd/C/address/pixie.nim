#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# External dependencies
import pkg/pixie

template caddr *(i :Image) :ptr ColorRGBX=  i.data[0].addr
