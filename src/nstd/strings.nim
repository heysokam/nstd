#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps nstd
import ./types as nstd

#_______________________________________
# @section strformat forward export
#_____________________________
import std/strformat ; export strformat

#________________________________________________________
# @section strutils wrapper without empty string f*kery  |
#________________________________________________________|
# @deps std
import std/strutils as utils ; export utils except contains
from   std/strutils as std import nil
#_______________________________________
proc contains *(A,B :string) :bool=
  ## @reason for this section to exist:
  ##  assert A != "" and B != "", "Comparing two empty strings with `contains` is undecidable"
  ##  Strings in nim are considered sets, and the empty set triggers a Vacuous_truth in std.contains
  ##  https://en.wikipedia.org/wiki/Vacuous_truth
  ##  https://en.wikipedia.org/wiki/Syntactic_ambiguity
  if   B == "" and A != "" : return false  # "" in "something" == true   is just plain wrong
  elif A == "" and B == "" : return false  # undecidable. commit to false because nothing cannot contain anything
  elif B == A              : return true
  else: std.contains(A,B)
#_______________________________________________________|


#_______________________________________
# @section Cstring Array tools
#_____________________________
type CstrArray * = distinct cstringArray
proc new *(_:typedesc[CstrArray]; list :openArray[string]) :CstrArray=
  allocCstringArray(list).CstrArray
proc `=destroy` *(arr :CstrArray) :void=
  deallocCstringArray(arr.cstringArray)
