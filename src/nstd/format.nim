#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
import std/strformat
import std/strutils


#____________________
type LineSeparator * = enum bStart, bEnd, cStart, cEnd, genericSep  # b = block ; c = category
#____________________
template blockStart *() :string=  "____________________"
template blockEnd   *() :string=  "____________________"
template catStart   *() :string=  ":: _________________"
template catEnd     *() :string=  ":: _______________::"
#____________________
proc lineSep *(sep :LineSeparator) :void= 
  case sep
  of   bStart:     echo blockStart()
  of   bEnd:       echo blockEnd()
  of   cStart:     echo catStart()
  of   cEnd:       echo catEnd()
  of   genericSep: echo blockStart()
#____________________
proc lineSep *() :void= lineSep(genericSep)
#____________________


#____________________
proc reprb *[T](n :var T) :string=  cast[ByteAddress](n.addr).repr
  ## Returns the string representation of an address.
proc repra *[T](n :var T) :string=  n.addr.repr & " " & n.reprb
  ## Returns the string representation of an address.
  ## Same as reprb, with better formatting


#_______________________________________
# Case Conversion
#___________________
type CaseType * = enum
  PascalCase, camelCase, snake_case, SCREAM_CASE
#_______________________________________
# First Character only
func firstLower (s :string) :string=  result = s; result[0] = result[0].toLowerAscii()
  ## Returns the string with its first character converted to lowercase
func firstUpper (s :string) :string=  result = s; result[0] = result[0].toUpperAscii()
  ## Returns the string with its first character converted to Uppercase
#_______________________________________
# PascalCase
func pascalToCamel (s :string) :string=
  result = s.firstLower()
func pascalToSnake (s :string) :string=
  for ch in s.firstLower():
    if ch.isUpperAscii : result.add( &"_{ch.toLowerAscii()}" )
    else               : result.add ch
func pascalToScream (s :string) :string=
  for ch in s.firstLower():
    if ch.isUpperAscii : result.add( &"_{ch}" )
    else               : result.add ch.toUpperAscii()
func pascalTo (s :string; trg :CaseType) :string=
  case trg
  of PascalCase  : result = s
  of camelCase   : result = s.pascalToCamel()
  of snake_case  : result = s.pascalToSnake()
  of SCREAM_CASE : result = s.pascalToScream()
#_______________________________________
# camelCase
func camelToPascal (s :string) :string=
  result = s.firstUpper()
func camelToSnake (s :string) :string=
  for ch in s:
    if ch.isUpperAscii : result.add( &"_{ch.toLowerAscii()}")
    else               : result.add ch
func camelToScream (s :string) :string=
  for ch in s:
    if ch.isUpperAscii : result.add( &"_{ch}" )
    else               : result.add ch.toUpperAscii()
func camelTo (s :string; trg :CaseType) :string=
  case trg
  of PascalCase  : result = s.camelToPascal()
  of camelCase   : result = s
  of snake_case  : result = s.camelToSnake()
  of SCREAM_CASE : result = s.camelToScream()
#_______________________________________
# snake_case
func snakeToPascal (s :string) :string=
  var nextHi = true # start true so the first character is converted to Uppercase
  for ch in s:
    if nextHi      : result.add ch.toUpperAscii; nextHi = false
    elif ch == '_' : nextHi = true
    else           : result.add ch
func snakeToCamel  (s :string) :string=
  var nextHi = false # start false so the first character is not converted to Uppercase
  for ch in s:
    if nextHi      : result.add ch.toUpperAscii; nextHi = false
    elif ch == '_' : nextHi = true
    else           : result.add ch
func snakeToScream (s :string) :string=
  for ch in s:
    if ch == '_' : result.add ch
    else         : result.add ch.toUpperAscii
func snakeTo (s :string; trg :CaseType) :string=
  case trg
  of PascalCase  : result = s.snakeToPascal()
  of camelCase   : result = s.snakeToCamel()
  of snake_case  : result = s
  of SCREAM_CASE : result = s.snakeToScream()
#_______________________________________
# SCREAM_CASE
func screamToPascal (s :string) :string=
  var nextHi = true # start true so the first character is kept as Uppercase
  for ch in s:
    if ch == '_' : nextHi = true; continue
    elif nextHi  : result.add ch.toUpperAscii; nextHi = false
    else         : result.add ch.toLowerAscii
func screamToCamel  (s :string) :string=
  var nextHi = false # start false so the first character is converted to lowercase
  for ch in s:
    if ch == '_' : nextHi = true; continue
    elif nextHi  : result.add ch.toUpperAscii; nextHi = false
    else         : result.add ch.toLowerAscii
func screamToSnake  (s :string) :string=
  for ch in s:
    if ch.isUpperAscii: result.add ch.toLowerAscii
    else: result.add ch
func screamTo (s :string; trg :CaseType) :string=
  case trg
  of PascalCase  : result = s.screamToPascal()
  of camelCase   : result = s.screamToCamel()
  of snake_case  : result = s.screamToSnake()
  of SCREAM_CASE : result = s
#_______________________________________
# External Interface
func change *(s :string; src,trg :CaseType) :string=
  if s == "": return s
  case src
  of PascalCase:  result = s.pascalTo(trg)
  of camelCase:   result = s.camelTo(trg)
  of snake_case:  result = s.snakeTo(trg)
  of SCREAM_CASE: result = s.screamTo(trg)

