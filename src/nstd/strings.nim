#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________


#_______________________________________________
# strutils wrapper without empty string f*kery  |
#_______________________________________________|
import std/strutils as utils except contains ; export utils
from   std/strutils as std   import nil
#_______________________________________
proc contains *(A,B :string) :bool=
  # The reason for this file to exist:
  # assert A != "" and B != "", "Comparing two empty strings with `contains` is undecidable"
  if   B == ""             : return false  # "" in "something" == true   is just plain wrong
  elif A == "" and B == "" : return false  # undecidable. make it finite by committing to false. nothing cannot contain anything, not even nothing
  elif B == A              : return true
  else: std.contains(A,B)
#_______________________________________________|
