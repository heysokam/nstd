#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
from std/strutils import join
# @deps nstd
import ./cfg


#_______________________________________
# @section Exception Tools
#_____________________________
func trigger *(
    excp : typedesc[CatchableError];
    msg  : varargs[string, `$`];
    pfx  : string = cfg.Prefix;
  ) :void=
  ## @descr
  ##  Raises the given {@arg err} with formatted {@arg msg} and {@arg pfx}.
  ##  Uses the default {@link cfg.Prefix} when omitted.
  raise newException(excp, pfx & ": " & msg.join(" "))

