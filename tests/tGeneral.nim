#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
include ./base


#____________________________________________________
test nstd.Prefix&" Convert: Array to String":
  check  ['a','b','c'].toString() == "abc"
  check @['a','b','c'].toString() == "abc"

#____________________________________________________
test nstd.Prefix&" Defines":
  check not NimScript

#____________________________________________________
test nstd.Prefix&" Directories":
  check projectDir() == ""

#____________________________________________________
test nstd.Prefix&" Iterators":  # NOTE: should be separate file when there are more
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
test nstd.Prefix&" Type Tools":
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
test nstd.Prefix&" Markers: Todo template":
  todo("testing"): "todo test0"
  todo "this is a todo test"
  check report() == """
two
  tGeneral.nim(49,20): todo test2
testing
  tGeneral.nim(53,6): todo test0
nstd
  tGeneral.nim(54,2): this is a todo test
three
  tGeneral.nim(50,20): todo test3
todo
  tGeneral.nim(48,20): todo test
"""

#____________________________________________________
test nstd.Prefix&" Markers: Unreachable":
  proc marker=
    if    false: discard
    elif  false: discard
    else: unreachable "----unreachable reason----"
  try: marker(); check false
  except Unreachable: check true

