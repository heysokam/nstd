#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# External dependencies
import pkg/vmath

template caddr *(m :var Mat4) :ptr float32=   m[0,0].addr
template caddr *(v :var Vec2) :ptr float32=   v.x.addr
template caddr *(v :var Vec3) :ptr float32=   v.x.addr
template caddr *(v :var Vec4) :ptr float32=   v.x.addr

