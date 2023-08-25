#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/unittest
# n*std dependencies
import nstd
# Specific for this test
import std/monotimes
import std/times


#____________________________________________________
test nstd.Prefix&" Time: Times":
  let a = nstd.time.get()
  let b = nstd.time.get()
  check a < b
  check a.nsec == a.ticks
  check a.msec == a.ticks/1_000_000
  check a.sec  == a.ticks/1_000_000_000

#____________________________________________________
test nstd.Prefix&" Time: Durations":
  let a  = nstd.time.get()
  let b  = nstd.time.get()
  let d  = b-a
  let a2 = nstd.time.get()
  let b2 = nstd.time.get()
  let d2 = b2-a2
  check d.nsec == d.inNanoseconds
  check d.msec == d.inMilliseconds
  check d.sec  == d.inSeconds
  check d.toMsec is float64
  check d.toSec  is float64
  check min( d, d+d2 ) == d
  check max( d, d+d2 ) == d+d2
  check nstd.time.msec() is float64
  check nstd.time.sec()  is float64

