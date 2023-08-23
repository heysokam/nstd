#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/times ; export Time, Duration, initDuration, `-`, `+=`, `<=`, `-=`, `<`, `+`
# Module dependencies
import ./types

# TODO:
# Remember std/monotimes

#____________________
# Tools for calculating time
proc msec     *(t :Time)          :f64=  t.nanosecond/1_000_000
proc sec      *(t :Time)          :f64=  t.nanosecond/1_000_000_000
proc nsec     *(d :Duration)      :i64=  d.inNanoseconds
proc msec     *(d :Duration)      :i64=  d.inMilliseconds
proc sec      *(d :Duration)      :i64=  d.inSeconds
proc toMsec   *(d :Duration)      :f64=  d.nsec.f64/1_000_000
proc toSec    *(d :Duration)      :f64=  d.nsec.f64/1_000_000_000
proc divToMs  *(d1, d2 :Duration) :f64=  (d1.nsec.f64 / d2.nsec.f64)/1_000_000
proc divToSec *(d1, d2 :Duration) :f64=  (d1.nsec.f64 / d2.nsec.f64)/1_000_000_000
proc min      *(d1, d2 :Duration) :Duration {.inline.}=
  ## Minimum operator for two Durations, based on `<=`
  if d1 <= d2: d1 else: d2

#____________________
# Get current time in different formats
proc msec *() :f64=  getTime().msec
  ## Gets the current time in miliseconds
proc sec  *() :f64=  getTime().sec
  ## Gets the current time in seconds
#____________________
proc get  *() :Time=  getTime()
  ## Gets the current time in the default engine format
  ## Alias to avoid potentially forgetting to change code 
  ## when changing the time format in multiple places

