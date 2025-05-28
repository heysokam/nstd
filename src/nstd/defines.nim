#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________


#____________________________________________________
const NimScript * = defined(nimscript) or defined(js)
  ## @descr
  ##  True for the nimscript and js targets.
  ##  Same as `WeirdTarget` from std, but with a clearer name pointing at the -language- features.
#____________________________________________________
const debug *{.booldefine.}= defined(debug) or not (defined(release) or defined(danger))
  ## @descr True when neither `-d:release` or `-d:danger` are defined on CLI, or when `-d:debug` is defined
const release *{.booldefine.}= defined(release) or defined(danger)
  ## @descr True when `-d:release` or `-d:danger` are defined on CLI
const danger *{.booldefine.}= defined(danger)
  ## @descr True when `-d:danger` is defined on CLI

