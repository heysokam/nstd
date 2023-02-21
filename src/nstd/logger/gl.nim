#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/times
import std/strformat
# External dependencies
import pkg/opengl  # Cannot come from our gl.nim, because of cyclic dependency
# Lib dependencies
import ../io
import ../format
import ../C/address
# Module dependencies
import ./cfg
import ./base

#______________________________
# OpenGL logging
#______________________________
type LogGLparm * = object
  id   :uint
  name :string
  typ  :string
converter toLogGLparm *(tup :tuple[id :uint, name, typ :string]) :LogGLparm=  LogGLparm(id: tup.id, name: tup.name, typ: tup.typ)
# converter toUint *(id :gl.Enum) :uint=  id.uint
#______________________________
const glParamT :seq[tuple[id :GLEnum, name, typ :string]]= @[
  (GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS, "GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS", "int"), #0
  (       GL_MAX_CUBE_MAP_TEXTURE_SIZE,        "GL_MAX_CUBE_MAP_TEXTURE_SIZE", "int"), #1
  (                GL_MAX_DRAW_BUFFERS,                 "GL_MAX_DRAW_BUFFERS", "int"), #2
  ( GL_MAX_FRAGMENT_UNIFORM_COMPONENTS,  "GL_MAX_FRAGMENT_UNIFORM_COMPONENTS", "int"), #3
  (         GL_MAX_TEXTURE_IMAGE_UNITS,          "GL_MAX_TEXTURE_IMAGE_UNITS", "int"), #4
  (                GL_MAX_TEXTURE_SIZE,                 "GL_MAX_TEXTURE_SIZE", "int"), #5
  (              GL_MAX_VARYING_FLOATS,               "GL_MAX_VARYING_FLOATS", "int"), #6
  (              GL_MAX_VERTEX_ATTRIBS,               "GL_MAX_VERTEX_ATTRIBS", "int"), #7
  (  GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS,   "GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS", "int"), #8
  (   GL_MAX_VERTEX_UNIFORM_COMPONENTS,  "GL_MAX_FRAGMENT_UNIFORM_COMPONENTS", "int"), #9
  (               GL_MAX_VIEWPORT_DIMS,                "GL_MAX_VIEWPORT_DIMS", "int2"), #10
  (                          GL_STEREO,                           "GL_STEREO", "bool"), #11
]
#______________________________
proc logGL *(msg, file :string; nl :bool= true) :void= 
  file.append(if not nl: msg else: msg & "\n")
  msg.log
#______________________________
proc logGLparms *(file :string) :void=
  blockStart().logGL(file)
  "GL Context Parameters:".logGL(file)
  for param in glParamT:
    if param.typ in ["int"]:  # Integers: The parameter will be one int
      var v :GLint= 0
      glGetIntegerv(param.id, v.caddr)
      (&"{param.name} {v}").logGL(file)
    elif param.typ in ["int2"]: # Int2 : The parameter will be an array of two ints
      var arr :array[2, GLint]
      glGetIntegerv(param.id, arr[0].addr);
      (&"{param.name} {arr[0]} {arr[1]}").logGL(file)
    elif param.typ in ["bool"]: # bool : The parameter will be true/false
      var b :GLboolean
      glGetBooleanv(param.id, b.addr)
      (&"{param.name} {b}").logGL(file)
    else: continue
  blockEnd().logGL(file)
#______________________________
proc logGLRestartFile *(file :string) :void= 
  file.writeFile(&"{blockStart()}\n:: Local time {now()}\n")
#______________________________
proc logGLerr *(msg, file :string) :void= msg.logGL(file); stderr.write(msg)
#______________________________
