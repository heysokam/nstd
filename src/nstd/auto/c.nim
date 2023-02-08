#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________

converter toCint *(cond :bool) :cint=  result = if cond: 1.cint else: 0.cint
  ## Converts the bool to cint. True will be 1, false will be 0.

