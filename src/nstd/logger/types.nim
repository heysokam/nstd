#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  |
#:____________________________________________________

#____________________
# Types
type LogFunc  * = proc (args: varargs[string])
proc noLog *(args: varargs[string, `$`]) :void= discard


