#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/times
import std/strformat
# External dependencies
import pkg/opengl  # Cannot be taken from render/gl.nim, because of cyclic dep hell
# Engine dependencies
import ../../cfg
import ../../files/io
import ../../render/types/gl
# Module dependencies
import ../format
import ./base

#______________________________
# OpenGL logging
#______________________________
#______________________________
type LoggGLparm * = object
  id   :uint
  name :string
  typ  :string
converter toLoggGLparm *(tup :tuple[id :uint, name, typ :string]) :LoggGLparm= LoggGLparm(id: tup.id, name: tup.name, typ: tup.typ)
converter toUint *(id :GLenum) :uint= id.uint
#______________________________
const glParamT :seq[tuple[id :GLenum, name, typ :string]]= @[
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
proc loggGL *(msg :string; nl :bool= true) :void= 
  LoggGLfile.append(if not nl: msg else: msg & "\n")
  msg.logg
#______________________________
proc loggGLparms *() :void=
  blockStart().loggGL
  "GL Context Parameters:".loggGL
  for param in glParamT:
    if param.typ in ["int"]:  # Integers: The parameter will be one int
      var v :GLint= 0
      glGetIntegerv(param.id, v.caddr)
      (&"{param.name} {v}").loggGL
    elif param.typ in ["int2"]: # Int2 : The parameter will be an array of two ints
      var arr :array[2, GLint]
      glGetIntegerv(param.id, arr[0].addr);
      (&"{param.name} {arr[0]} {arr[1]}").loggGL
    elif param.typ in ["bool"]: # bool : The parameter will be true/false
      var b :GLboolean
      glGetBooleanv(param.id, b.addr)
      (&"{param.name} {b}").loggGL
    else: continue
  blockEnd().loggGL
#______________________________
proc loggGLRestartFile *() :void= 
  LoggGLfile.writeFile(&"{blockStart()}\n:: Local time {now()}\n")
#______________________________
proc loggGLerr *(msg :string) :void= msg.loggGL; stderr.write(msg)
#______________________________
