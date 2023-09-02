#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# std dependencies
from std/paths import Path


#_______________________________________
# Zig inspired type aliases
#___________________
type i8   * = int8
type u8   * = uint8
type i16  * = int16
type u16  * = uint16
type i32  * = int32
type u32  * = uint32
type i64  * = int64
type u64  * = uint64
type f32  * = float32
type f64  * = float64
type str  * = string
type cstr * = cstring


#_______________________________________
# Other aliases
#___________________
type ByteAddr * = uint
  ## Alias for ByteAddress, which was deprecated in favor of `uint`, which is not readable


#_______________________________________
# Extensions
#___________________
type PathFile * = object
  ## A type that contains a Path, its File handle and its opening mode
  path   *:Path
  handle *:File
  mode   *:FileMode

