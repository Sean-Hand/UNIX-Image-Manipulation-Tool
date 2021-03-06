# Copyright (c) 2002 Kitware, Inc., Insight Consortium
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#  * Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
#  * The names of Kitware, Inc., the Insight Consortium, or the names of
#    any consortium members, or of any contributors, may not be used to
#    endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# - Check if the DIR symbol exists like in AC_HEADER_DIRENT.
# CHECK_DIRSYMBOL_EXISTS(FILES VARIABLE)
#
#  FILES    - include files to check
#  VARIABLE - variable to return result
#
# This module is a small but important variation on CheckSymbolExists.cmake.
# The symbol always searched for is DIR, and the test programme follows
# the AC_HEADER_DIRENT test programme rather than the CheckSymbolExists.cmake
# test programme which always fails since DIR tends to be typedef'd
# rather than #define'd.
#
# The following variables may be set before calling this macro to
# modify the way the check is run:
#
#  CMAKE_REQUIRED_FLAGS = string of compile command line flags
#  CMAKE_REQUIRED_DEFINITIONS = list of macros to define (-DFOO=bar)
#  CMAKE_REQUIRED_INCLUDES = list of include directories
#  CMAKE_REQUIRED_LIBRARIES = list of libraries to link

MACRO(CHECK_DIRSYMBOL_EXISTS FILES VARIABLE)
  IF(NOT DEFINED ${VARIABLE})
    SET(CMAKE_CONFIGURABLE_FILE_CONTENT "/* */\n")
    SET(MACRO_CHECK_DIRSYMBOL_EXISTS_FLAGS ${CMAKE_REQUIRED_FLAGS})
    IF(CMAKE_REQUIRED_LIBRARIES)
      SET(CHECK_DIRSYMBOL_EXISTS_LIBS
        "-DLINK_LIBRARIES:STRING=${CMAKE_REQUIRED_LIBRARIES}")
    ELSE(CMAKE_REQUIRED_LIBRARIES)
      SET(CHECK_DIRSYMBOL_EXISTS_LIBS)
    ENDIF(CMAKE_REQUIRED_LIBRARIES)
    IF(CMAKE_REQUIRED_INCLUDES)
      SET(CMAKE_DIRSYMBOL_EXISTS_INCLUDES
        "-DINCLUDE_DIRECTORIES:STRING=${CMAKE_REQUIRED_INCLUDES}")
    ELSE(CMAKE_REQUIRED_INCLUDES)
      SET(CMAKE_DIRSYMBOL_EXISTS_INCLUDES)
    ENDIF(CMAKE_REQUIRED_INCLUDES)
    FOREACH(FILE ${FILES})
      SET(CMAKE_CONFIGURABLE_FILE_CONTENT
        "${CMAKE_CONFIGURABLE_FILE_CONTENT}#include <${FILE}>\n")
    ENDFOREACH(FILE)
    SET(CMAKE_CONFIGURABLE_FILE_CONTENT
      "${CMAKE_CONFIGURABLE_FILE_CONTENT}\nint main()\n{if ((DIR *) 0) return 0;}\n")

    CONFIGURE_FILE("${CMAKE_ROOT}/Modules/CMakeConfigurableFile.in"
      "${CMAKE_BINARY_DIR}/CMakeFiles/CMakeTmp/CheckDIRSymbolExists.c" @ONLY)

    MESSAGE(STATUS "Looking for DIR in ${FILES}")
    TRY_COMPILE(${VARIABLE}
      ${CMAKE_BINARY_DIR}
      ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeTmp/CheckDIRSymbolExists.c
      COMPILE_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS}
      CMAKE_FLAGS
      -DCOMPILE_DEFINITIONS:STRING=${MACRO_CHECK_DIRSYMBOL_EXISTS_FLAGS}
      "${CHECK_DIRSYMBOL_EXISTS_LIBS}"
      "${CMAKE_DIRSYMBOL_EXISTS_INCLUDES}"
      OUTPUT_VARIABLE OUTPUT)
    IF(${VARIABLE})
      MESSAGE(STATUS "Looking for DIR in ${FILES} - found")
      SET(${VARIABLE} 1 CACHE INTERNAL "Have symbol DIR")
      FILE(APPEND ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeOutput.log
        "Determining if the DIR symbol is defined as in AC_HEADER_DIRENT "
        "passed with the following output:\n"
        "${OUTPUT}\nFile ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeTmp/CheckDIRSymbolExists.c:\n"
        "${CMAKE_CONFIGURABLE_FILE_CONTENT}\n")
    ELSE(${VARIABLE})
      MESSAGE(STATUS "Looking for DIR in ${FILES} - not found.")
      SET(${VARIABLE} "" CACHE INTERNAL "Have symbol DIR")
      FILE(APPEND ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeError.log
        "Determining if the DIR symbol is defined as in AC_HEADER_DIRENT "
        "failed with the following output:\n"
        "${OUTPUT}\nFile ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeTmp/CheckDIRSymbolExists.c:\n"
        "${CMAKE_CONFIGURABLE_FILE_CONTENT}\n")
    ENDIF(${VARIABLE})
  ENDIF(NOT DEFINED ${VARIABLE})
ENDMACRO(CHECK_DIRSYMBOL_EXISTS)
