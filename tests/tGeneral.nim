#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
include ./base


#____________________________________________________
suite nstd.Prefix&" Convert":
  test "Array to String":
    check  ['a','b','c'].toString() == "abc"
    check @['a','b','c'].toString() == "abc"

#____________________________________________________
suite nstd.Prefix&" Defines":
  test "nimscript":
    check not defines.NimScript
  test "debug":
    check defines.debug == not (defined(release) or defined(danger)) or defined(debug)

#____________________________________________________
suite nstd.Prefix&" Iterators":  # NOTE: should be separate file when there are more
  test "twoD":
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
suite nstd.Prefix&" Type Tools":
  test "isType":
    let one,two :string= ""
    let other :u8= 0
    check (one,two).isType(string)
    check not (one,other).isType(string)
  #________________________
  test "isObject":
    type MyObj = object
    type MyRef = ref object
    check MyObj.isObject() and MyRef.isObject()
  #________________________
  test "new T":
    type MyObj = object
    var val = MyObj()
    check val.new() is ref MyObj

suite nstd.Prefix&" Markers":
  #_____________________________
  proc  test ()= todo("todo"): "todo test"
  proc test2 ()= todo("two"): "todo test2"
  proc test3 ()= todo("three"): "todo test3"
  #_____________________________
  test nstd.Prefix&"Todo template":
    todo("testing"): "todo test0"
    todo "this is a todo test"
    check report() == """
two
  tGeneral.nim(55,21): todo test2
testing
  tGeneral.nim(59,8): todo test0
nstd
  tGeneral.nim(60,4): this is a todo test
three
  tGeneral.nim(56,21): todo test3
todo
  tGeneral.nim(54,21): todo test
"""
  #_____________________________
  test "Unreachable":
    proc marker=
      if    false: discard
      elif  false: discard
      else: unreachable "----unreachable reason----"
    expect Unreachable: marker()

