#:____________________________________________________
#  nstd  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:____________________________________________________
# @deps All Tests
include ../base
# @deps std
from std/os import nil
import std/importutils as imp
# @deps n*std.paths
import nstd/paths/types {.all.} as paths
# @deps Paths Tests
import ./data


#_______________________________________
# @section Paths: Files
#_____________________________
suite "Paths: File Tools":
  var Hello_Read :string
  #_____________________________
  setup: # Generate the dummy data files
    system.writeFile(Hello.Path.path, Hello.Data)
    Hello_Read = system.readFile( Hello.Path.path )
  teardown:
    os.removeFile(Hello.Path.path)

  #_____________________________
  test "Path.read":
    check Hello.Path.read() == Hello.Data
    check Hello.Path.read() == Hello_Read
  #_____________________________
  test "Path.write":
    os.removeFile(Hello.Path.path)
    Hello.Path.write(Hello.Data)
    check system.readFile(Hello.Path.path) == Hello_Read
  #_____________________________
  test "Path.remove":
    Hello.Path.remove()
    check os.fileExists(Hello.Path.path) == false
  #_____________________________
  test "Path.erase":
    check os.fileExists(Hello.Path.path)   == true
    check system.readFile(Hello.Path.path) == Hello_Read
    check Hello_Read != ""
    Hello.Path.erase()
    check system.readFile(Hello.Path.path) != Hello_Read
    check system.readFile(Hello.Path.path) == ""

