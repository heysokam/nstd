#:________________________________________
#  Copyright (C) Ivan Mar (sOkam!) : MIT :
#:________________________________________
# std dependencies
import std/strformat
# External dependencies
import pkg/chroma
import pkg/opengl
# Module dependencies
import ./logger  # For debug logging functions
import ./format  # For debug text formatting

#______________________________________________
# Renaming style:
# Constants are PascalCase
# Functions are camelCase
# Some functions are overloaded to Nim types
# Some functionality is unified or simplified, like `gl.init()` or `gl.clear()`
# Some names are shortened, like `Tex2D` instead of GL_TEXTURE_2D
# Some names are reworded for categorization priority, like FilterMag instead of GL_TEXTURE_MAG_FILTER
# Lack of parenthesis right next to GL types means type conversion. Like   GLint loc   is converting loc nim type to GLint
#______________________________________________

#______________________________________________
# GL helpers
#___________________
converter toBool  *(cond :GLboolean) :bool=   cond == GL_TRUE
converter toInt32 *(cond :GLboolean) :int32=  cond.ord.int32
#___________________
proc toString *(pc :ptr GLchar; length :GLsizei) :string=
  ## Gets a nim string for an OpenGL char pointer with the specified length
  result = newStringOfCap(length)
  for ch in cast[ptr UncheckedArray[char]](pc).toOpenArray(0, length-1):
    result.add(ch)

#______________________________________________
# Procedures: Custom
#___________________
proc init *() :void=  opengl.loadExtensions()
  ## Initializes the OpenGL context
  ## Shorthand for loadExtensions()
#____________________
proc clear *(color :Color= color(0.1, 0.1, 0.1, 1); colorBit :bool= true; depthBit :bool= true) :void=
  ## Clears the OpenGL context.
  ## Defaults when omitted:
  ## - color: 0.1 gray by default. pure magenta when debug
  ## - bits:  color and depth cleared
  # Clear color
  var c :Color= color
  when defined(debug): c = color(1,0,1,1) # Strong magenta for debug version
  glClearColor(c.r, c.g, c.b, c.a)
  # Clear bits
  var bits :GLbitfield
  if colorBit: bits = bits or GL_COLOR_BUFFER_BIT
  if depthBit: bits = bits or GL_DEPTH_BUFFER_BIT
  glClear(bits)
#____________________
proc debug *(src :GLenum; typ :GLenum; id :GLuint; sev :GLenum; length :GLsizei; msg :ptr GLchar; param :pointer) :void {.stdcall.}=
  ## Debug callback for OpenGL : glDebugMessageCallback
  ## https://www.khronos.org/opengl/wiki/Debug_Output
  if not (sev.int >= GLDebugSeverityLow.int): return
  var  source :string; case src
  of   GLDebugSourceApi:               source = "API"
  of   GLDebugSourceWindowSystem:      source = "Window System"
  of   GLDebugSourceShaderCompiler:    source = "Shader Compiler"
  of   GLDebugSourceThirdParty:        source = "Third Party"
  of   GLDebugSourceApplication:       source = "Application"
  of   GLDebugSourceOther:             source = "Other"
  else: discard
  var  typText :string; case typ
  of   GLDebugTypeError:               typText = "Error"
  of   GLDebugTypeDeprecatedBehavior:  typText = "Deprecated Behavior"
  of   GLDebugTypeUndefinedBehavior:   typText = "Undefined Behavior"
  of   GLDebugTypePortability:         typText = "Portability"
  of   GLDebugTypePerformance:         typText = "Performance"
  of   GLDebugTypeMarker:              typText = "Marker"
  of   GLDebugTypeOther:               typText = "Other"
  else: discard
  var  severity :string; case sev
  of   GLDebugSeverityNotification:    severity = "Notification"  # Anything that isn't an error or performance issue.
  of   GLDebugSeverityLow:             severity = "Low"           # Redundant state change performance warning, or unimportant undefined behavior
  of   GLDebugSeverityMedium:          severity = "Medium"        # Major performance warnings, shader compilation/linking warnings, or the use of deprecated functionality
  of   GLDebugSeverityHigh:            severity = "High"          # All OpenGL Errors, shader compilation/linking errors, or highly-dangerous undefined behavior
  else: discard
  logg &"OpenGL Debug {source}, {severity}, {typText}, {id.uint64}:\n:  {msg.toString(length)}"
  bEnd.lineSep

#____________________
proc setDebug *() :void=
  ## Set OpenGL debug mode. Does nothing in release mode (aka -d:danger)
  when not defined danger:
    glEnable(GLDebugOutput)
    glEnable(GLDebugOutputSynchronous)
    glDebugMessageCallback(debug, nil)
#____________________
proc setBlend *() :void=
  ## Set OpenGL blend mode
  glEnable(GLBlend)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
#____________________
proc setCull *() :void=
  ## Set OpenGL faceculling
  glEnable(GLCullFace)  # Default disabled
  glFrontFace(GLccw)    # Default CCW
  glCullFace(GLback)    # Default Back
#____________________
proc setDepth *() :void=  glEnable(GLDepthTest)   ## Enables OpenGL depth testing
proc disDepth *() :void=  glDisable(GLDepthTest)  ## Disables OpenGL depth testing


#____________________
# Types 
type  u32   * = GLuint
type  Size  * = GLsizei
type  i32   * = GLint
type  Bool  * = GLboolean
type  Enum  * = GLenum
const False * = GL_FALSE
const True  * = GL_TRUE
var   Float * = cGL_FLOAT

#____________________
# Info and Errors
const CompileStatus             * = GL_COMPILE_STATUS
const InfoLogLength             * = GL_INFO_LOG_LENGTH
const LinkStatus                * = GL_LINK_STATUS
const ValidateStatus            * = GL_VALIDATE_STATUS
const getIntegerv               * = glGetIntegerv
const getBooleanv               * = glGetBooleanv

#____________________
# Drawing mode
const polygonMode               * = glPolygonMode
const FrontAndBack              * = GL_FRONT_AND_BACK
const Line                      * = GL_LINE
const Fill                      * = GL_FILL

#____________________
# Shaders
## Vertex & Fragment
const VertexShader              * = GL_VERTEX_SHADER
const FragmentShader            * = GL_FRAGMENT_SHADER
const getShaderiv               * = glGetShaderiv
const getShaderInfoLog          * = glGetShaderInfoLog
const shaderSource              * = glShaderSource
const compileShader             * = glCompileShader
var   createShader              * = glCreateShader
const deleteShader              * = glDeleteShader
## Program
const attachShader              * = glAttachShader
const getProgramInfoLog         * = glGetProgramInfoLog
const getProgramiv              * = glGetProgramiv
const validateProgram           * = glValidateProgram
const useProgram                * = glUseProgram
const linkProgram               * = glLinkProgram
var   createProgram             * = glCreateProgram
const deleteProgram             * = glDeleteProgram
#____________________
# Buffers and Data: Non-DSA
## VAO
const genVertexArrays           * = glGenVertexArrays
var   bindVertexArray           * = glBindVertexArray
var   drawArrays                * = glDrawArrays
const Tris                      * = GL_TRIANGLES
## VBO
const genBuffers                * = glGenBuffers
const bindBuffer                * = glBindBuffer
const bufferData                * = glBufferData
const ArrayBuffer               * = GL_ARRAY_BUFFER
const ElementArrayBuffer        * = GL_ELEMENT_ARRAY_BUFFER
const StaticDraw                * = GL_STATIC_DRAW
## Attributes
const vertexAttribPointer       * = glVertexAttribPointer
var   enableVertexAttribArray   * = glEnableVertexAttribArray
const disableVertexAttribArray  * = glDisableVertexAttribArray
## Uniforms
const getUniformLocation        * = glGetUniformLocation
proc uniform1i  *(loc, v0 :SomeInteger) :void=  glUniform1i(GLint loc, GLint v0)
proc uniform1iv *(loc, count :SomeInteger; valptr :ptr GLint)   :void=  glUniform1iv(GLint loc, GLsizei count, valptr)
proc uniform1fv *(loc, count :SomeInteger; valptr :ptr GLfloat) :void=  glUniform1fv(GLint loc, GLsizei count, valptr)
proc uniform2fv *(loc, count :SomeInteger; valptr :ptr GLfloat) :void=  glUniform2fv(GLint loc, GLsizei count, valptr)
proc uniform3fv *(loc, count :SomeInteger; valptr :ptr GLfloat) :void=  glUniform3fv(GLint loc, GLsizei count, valptr)
proc uniform4fv *(loc, count :SomeInteger; valptr :ptr GLfloat) :void=  glUniform4fv(GLint loc, GLsizei count, valptr)
proc uniformMatrix4fv *(loc, count :SomeInteger; transpose :bool; valptr :ptr GLfloat) :void=
  glUniformMatrix4fv(GLint loc, GLsizei count, GLboolean transpose, valptr)
## Textures
const genTextures               * = glGenTextures
const bindTexture               * = glBindTexture
proc texImage2D *(target :GLenum; level :SomeInteger; internalformat :GLenum; width, height, border :SomeInteger; format, typ :GLenum; pixels :seq[ColorRGBX]) :void=
  glTexImage2D(target, GLint level, GLint internalFormat, GLsizei width, GLsizei height, border.GLint, format, typ, cast[pointer](pixels[0].unsafeAddr))
proc texImage2D *(target :GLenum; level :SomeInteger; internalformat :GLenum; width, height, border :SomeInteger; format, typ :GLenum; pixels :seq[ColorRGBA]) :void=
  glTexImage2D(target, GLint level, GLint internalFormat, GLsizei width, GLsizei height, border.GLint, format, typ, cast[pointer](pixels[0].unsafeAddr))
var   activeTexture             * = glActiveTexture
const Diffuse                   * = GL_TEXTURE0
### Tex: Parameters
var   texParameteri             * = glTexParameteri
const Tex2D                     * = GL_TEXTURE_2D
const FilterMag                 * = GL_TEXTURE_MAG_FILTER
const FilterMin                 * = GL_TEXTURE_MIN_FILTER
const Nearest                   * = GL_NEAREST
const WrapS                     * = GL_TEXTURE_WRAP_S
const WrapT                     * = GL_TEXTURE_WRAP_T
const Clamp                     * = GL_CLAMP
const Repeat                    * = GL_REPEAT
const LinearMipmapLinear        * = GL_LINEAR_MIPMAP_LINEAR
const Linear                    * = GL_LINEAR
### Tex: Formats
const Rgba                      * = GL_RGBA
const Rgba8                     * = GL_RGBA8
const uByte                     * = GL_UNSIGNED_BYTE
const uInt                      * = GL_UNSIGNED_INT

#____________________
# DSA: Textures
const bindTextureUnit           * = glBindTextureUnit
const createTextures            * = glCreateTextures
const textureParameteri         * = glTextureParameteri
const generateTextureMipmap     * = glGenerateTextureMipmap
const textureSubImage2D         * = glTextureSubImage2D
const textureStorage2D          * = glTextureStorage2D
# DSA: Buffers
const createBuffers             * = glCreateBuffers
const namedBufferStorage        * = glNamedBufferStorage
const DynamicStorageBit         * = GL_DYNAMIC_STORAGE_BIT
const unmapNamedBuffer          * = glUnmapNamedBuffer
const deleteBuffers             * = glDeleteBuffers
# DSA: VAO
const createVertexArrays        * = glCreateVertexArrays
const deleteVertexArrays        * = glDeleteVertexArrays
# DSA: VBO
const vertexArrayVertexBuffer   * = glVertexArrayVertexBuffer
# DSA: EBO
const vertexArrayElementBuffer  * = glVertexArrayElementBuffer
const drawElements              * = glDrawElements
# DSA: Attributes
const enableVertexArrayAttrib   * = glEnableVertexArrayAttrib
const vertexArrayAttribFormat   * = glVertexArrayAttribFormat
const vertexArrayAttribBinding  * = glVertexArrayAttribBinding
#____________________
# Window
const viewport                  * = glViewport
