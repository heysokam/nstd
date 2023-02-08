#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________

proc toVersU8 *(tup :tuple[major, minor :int]) :tuple[major, minor :uint8]=  (tup.major.uint8, tup.minor.uint8)
  ## Converts a (major, minor) int tuple into a (uint8, uint8) one
