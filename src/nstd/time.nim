#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/times     ; export Duration, initDuration
import std/monotimes ; export monotimes
# Module dependencies
import ./types


#_______________________________________
# Tools for calculating time
#___________________
# MonoTime
func nsec *(t :MonoTime) :i64 {.inline.}=  t.ticks
  ## Returns the given time in nanoseconds
func msec *(t :MonoTime) :f64 {.inline.}=  t.ticks/1_000_000
  ## Returns the given time in miliseconds
func sec  *(t :MonoTime) :f64 {.inline.}=  t.ticks/1_000_000_000
  ## Returns the given time in seconds
#___________________
# Duration
func nsec *(d :Duration) :i64 {.inline.}=  d.inNanoseconds
  ## Returns the given duration in nanoseconds
func msec *(d :Duration) :i64 {.inline.}=  d.inMilliseconds
  ## Returns the given duration in miliseconds
func sec *(d :Duration) :i64 {.inline.}=  d.inSeconds
  ## Returns the given duration in seconds
func toMsec *(d :Duration) :f64 {.inline.}=  d.nsec.f64/1_000_000
  ## Converts the given duration to its float64 miliseconds representation
func toSec *(d :Duration) :f64 {.inline.}=  d.nsec.f64/1_000_000_000
  ## Converts the given duration to its float64 seconds representation
func divToMsec *(d1, d2 :Duration) :f64 {.inline.}=  (d1.nsec.f64 / d2.nsec.f64)/1_000_000
  ## Divides both durations, and returns the result converted to its float64 miliseconds representation
func divToSec *(d1, d2 :Duration) :f64 {.inline.}=  (d1.nsec.f64 / d2.nsec.f64)/1_000_000_000
  ## Divides both durations, and returns the result converted to its float64 seconds representation
func min *(d1, d2 :Duration) :Duration {.inline.}=
  ## Returns the min of two Durations. Based on `<=`
  if d1 <= d2: d1 else: d2
func max *(d1, d2 :Duration) :Duration {.inline.}=
  ## Returns the max of two Durations. Based on `>=`
  if d1 >= d2: d1 else: d2

#_______________________________________
# Get current time in different formats
#___________________
proc nsec *() :i64 {.inline.}=  getMonotime().ticks
  ## Gets the current time in nanoseconds
proc msec *() :f64 {.inline.}=  getMonotime().msec
  ## Gets the current time in miliseconds
proc sec  *() :f64 {.inline.}=  getMonotime().sec
  ## Gets the current time in seconds
#___________________
proc get  *() :MonoTime {.inline.}=  getMonotime()
  ## Gets the current time in the default preferred format (MonoTime)
  ## Alias for ergonomics, so that time format can be changed from one single spot.
proc getReal *() :Time {.inline.}=  getTime()
  ## Gets the current real time.
  ## Only used for referencing against the real world, and never against other times.

