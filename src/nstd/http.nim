#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps external
import pkg/zippy
# @deps nstd
import ./shell


#___________________
proc dl *(args :varargs[string, `$`]) :void {.inline.}=
  when defined(nimscript) : sh "wget", args
  else                    : {.warning: "Downloading not implemented yet".} ; sh "wget", args
