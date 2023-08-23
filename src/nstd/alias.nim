#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/os


#_____________________________
const echod * = debugEcho
  ## Short Alias for debugEcho
#_____________________________
proc wait *(sec :int) :void=  sleep(sec*1000)
  ## Waits for the given number of seconds.
  ## Alias for std/os.sleep

