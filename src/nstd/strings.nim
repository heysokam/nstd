#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps nstd
import ./types as nstd


#_______________________________________
# @section std varargs string extensions
#_____________________________
func toString *(args :varargs[string]) :string=
  ## @descr Converts the given {@arg args} string varargs to a single string.
  for arg in args:  result.add arg
#___________________
var stdout {.importc: "stdout", header: "<stdio.h>".} :File
proc prnt *(args :varargs[string, `$`]) :void=  stdout.write toString(args)
  ## @descr Prints the {@arg args} varargs input to console. Same as {@link echo}, but without "\n" at the end.
#___________________


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
# @section strutils extensions
#_____________________________
proc startsWith *(word :string; args :varargs[string, `$`]) :bool=
  ## @descr Returns true if {@arg word} starts with any of the given {@arg args}
  for arg in args:
    if utils.startsWith(word, arg): return true
#___________________
proc endsWith *(word :string; args :varargs[string, `$`]) :bool=
  ## @descr Returns true if {@arg word} ends with any of the given {@arg args}
  for arg in args:
    if utils.endsWith(word, arg): return true


#_______________________________________
# @section New Utilities
#_____________________________
func wrapped *(val :string; safeWrap :bool= false) :string=
  ## @descr Returns {@arg val} wrapped between quotes
  ## @note Replaces every instance of \" with its escaped version when {@arg safeWrap} is true
  result.add "\""
  result.add if not safeWrap: val else: val.replace("\\\"", "\\\\\\\"")
  result.add "\""
#___________________
func wrappedIn *(val :string; before,after :char|string) :string=
  ## @descr Returns {@arg val} wrapped between characters {@arg before} and {@arg after}
  let bfr = when before is char: $before else: before
  let aft = when after  is char: $after  else: after
  result = bfr & val & aft
#___________________
func otherwise *(val,other :string) :string=
  ## @descr Returns {@arg other} if {@arg val} is empty or consists only of whitespace.
  if val.isEmptyOrWhitespace: other else: val


#_______________________________________
# @section Cstring Array tools
#_____________________________
type CStringImpl {.importc: "const char*".} = cstring
type CString * = distinct CStringImpl
  ## @descr True Cstring Implementation. Maps to a `const char*` in codegen
proc `$` *(s :CString) :string {.borrow.}


#_______________________________________
# @section Cstring Array tools
#_____________________________
type CstrArray * = distinct cstringArray
proc new *(_:typedesc[CstrArray]; list :openArray[string]) :CstrArray=
  allocCstringArray(list).CstrArray
proc `=destroy` *(arr :var CstrArray) :void=
  deallocCstringArray(arr.cstringArray)

