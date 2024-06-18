#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
include ./base

#____________________________________________________
test nstd.Prefix&" Size: number.toBytes converter":
  check  0.toBytes == uint32( 0 )
  check  8.toBytes == uint32( 1 )
  check 16.toBytes == uint32( 2 )
  check 32.toBytes == uint32( 4 )
  check 64.toBytes == uint32( 8 )
  for num in 1..<8: # Should fail cases
    try: discard num.toBytes; check false
    except AssertionDefect: check true

#____________________________________________________
type TestType = object
  data :array[42,char]

#____________________________________________________
test nstd.Prefix&" Size: Any Type.size":
  check  int16.size == uint64( 2 )
  check uint16.size == uint64( 2 )
  check  int32.size == uint64( 4 )
  check uint32.size == uint64( 4 )
  check  int64.size == uint64( 8 )
  check uint64.size == uint64( 8 )
  check TestType.size == uint64( 42 )

#____________________________________________________
test nstd.Prefix&" Size: Any value.size":
  let v1 :int16= 1
  let v2 :int32= 2
  let v3 :int64= 3
  let t1 = TestType()
  check v1.size == uint64( 2 )
  check v2.size == uint64( 4 )
  check v3.size == uint64( 8 )
  check t1.size == uint64( 42 )

#____________________________________________________
test nstd.Prefix&" Size: Any openArray.size":
  let s2 :array[3,char] =  ['a','b','c']
  let s1 :seq[char]     = @['a','b','c']
  check    s1.size == uint64( 3 )
  check    s2.size == uint64( 3 )
  check s1.csizeof == cint( 3 )
  check s2.csizeof == cint( 3 )

#____________________________________________________
test nstd.Prefix&" Size: Alignment":
  check 64.alignTo(2) == 64
  check 63.alignTo(2) == 64
  check 62.alignTo(2) == 62
  check 61.alignTo(2) == 62
  #________________________
  check 64.alignTo(8) == 64
  check 61.alignTo(8) == 64
  check 57.alignTo(8) == 64
  check 56.alignTo(8) == 56
  #________________________
  check 64.alignTo4() == 64
  check 63.alignTo4() == 64
  check 62.alignTo4() == 64
  check 61.alignTo4() == 64
  check 60.alignTo4() == 60
  #________________________
  check 64.alignTo(u8) == 64.alignTo8()
  check 61.alignTo(u8) == 61.alignTo8()
  check 57.alignTo(u8) == 57.alignTo8()
  check 56.alignTo(u8) == 56.alignTo8()
  #________________________
  check 64.alignTo(u16) == 64.alignTo(16)
  check 54.alignTo(u32) == 54.alignTo(32)
  check 31.alignTo(u64) == 31.alignTo(64)

