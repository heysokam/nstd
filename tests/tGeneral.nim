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
