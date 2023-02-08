#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/os

const echod * = debugEcho
  ## Short Alias for debugEcho

proc wait *(sec :int) :void=  sleep(sec*1000)
  ## Waits for the given number of seconds.
  ## Alias for std/os.sleep

