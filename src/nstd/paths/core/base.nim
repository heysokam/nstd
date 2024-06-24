#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps std
from std/paths as std import nil


template toStdPath *(S :string | std.Path) :untyped=
  ## @descr Helper to remove type translation boilerplate
  when S is string: std.Path(S) else: S

