#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/unittest
# n*std dependencies
import nstd
# tests dependencies
import ./cfg


#____________________________________________________
test cfg.Prefix&"Convert: Array to String":
  check  ['a','b','c'].toString() == "abc"
  check @['a','b','c'].toString() == "abc"

#____________________________________________________
test cfg.Prefix&"Defines":
  check not NimScript

#____________________________________________________
test cfg.Prefix&"Directories":
  check projectDir() == ""

#____________________________________________________
test cfg.Prefix&"Iterators":  # NOTE: should be separate file when there are more
  const bytesK = [
    255'u8,255,255,255,
       255,255,255,255,
       255,255,255,255,
       255,255,255,255,
    ] # << bytesK[ ]
  var bytes :array[16,u8]
  for byte in bytes.twoD(4,4):
    if byte == 0: byte = 255
  for id,byte in bytes.pairs: check bytes[id] == bytesK[id]

#____________________________________________________
test cfg.Prefix&"Type Tools":
  let one,two :string= ""
  let other :u8= 0
  check (one,two).isType(string)
  check not (one,other).isType(string)
  #________________________
  type MyObj = object
  type MyRef = ref object
  check MyObj.isObject() and MyRef.isObject()
  #________________________
  var val = MyObj()
  check val.new() is ref MyObj

#____________________________________________________
proc  test *()= todo("todo"): "todo test"
proc test2 *()= todo("two"): "todo test2"
proc test3 *()= todo("three"): "todo test3"
#____________________________________________________
test cfg.Prefix&"Markers: Todo template":
  todo("testing"): "todo test0"
  todo "this is a todo test"
  check report() == """
two
  tGeneral.nim(54,20): todo test2
testing
  tGeneral.nim(58,6): todo test0
nstd
  tGeneral.nim(59,2): this is a todo test
three
  tGeneral.nim(55,20): todo test3
todo
  tGeneral.nim(53,20): todo test
"""

#____________________________________________________
test cfg.Prefix&"Markers: Unreachable":
  proc marker=
    if    false: discard
    elif  false: discard
    else: unreachable "----unreachable reason----"
  try: marker(); check false
  except Unreachable: check true

