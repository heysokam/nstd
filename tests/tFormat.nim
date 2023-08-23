import std/unittest
import nstd
test "can add": check 5+5 == 10
test "SCREAM_CASE":
  check "MAKE_API_VERSION".change(SCREAM_CASE, camelCase) ==  "makeApiVersion"
