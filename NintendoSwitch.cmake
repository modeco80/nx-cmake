set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR armv8-a)

set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
set(CMAKE_STATIC_LIBRARY_SUFFIX_C "${CMAKE_STATIC_LIBRARY_SUFFIX}")
set(CMAKE_STATIC_LIBRARY_SUFFIX_CXX "${CMAKE_STATIC_LIBRARY_SUFFIX}")

set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C "${CMAKE_EXECUTABLE_SUFFIX}")
set(CMAKE_EXECUTABLE_SUFFIX_CXX "${CMAKE_EXECUTABLE_SUFFIX}")

# allow CMake projects to detect NX compilation
set(NX TRUE)


macro(msys_to_cmake MsysPath ResultingPath)
	if(WIN32)
		# Msys2
		string(REGEX REPLACE "^/([a-zA-Z])/" "\\1:/" ${ResultingPath} "${MsysPath}")
	else()
		# Paths are ok already
		set(${ResultingPath} "${MsysPath}")
	endif()
endmacro()

# Setup paths
msys_to_cmake("$ENV{DEVKITPRO}" DEVKITPRO)
if(NOT IS_DIRECTORY ${DEVKITPRO})
	message(FATAL_ERROR "devkitPro not found, please install to compile NX applications")
endif()

# ??? devkitA64 does not have a enviroment variable
# (at least, not using the Windows installer)
# change out when this is fixed've by the dkp team
msys_to_cmake("${DEVKITPRO}/devkitA64" DEVKITA64)
if(NOT IS_DIRECTORY ${DEVKITA64})
	message(FATAL_ERROR "devkitA64 not found, please install to compile NX applications")
endif()

# Set the GNU compilers for AArch64
if(WIN32)
    set(CMAKE_C_COMPILER "${DEVKITA64}/bin/aarch64-none-elf-gcc.exe")
    set(CMAKE_CXX_COMPILER "${DEVKITA64}/bin/aarch64-none-elf-g++.exe")
    set(CMAKE_AR "${DEVKITA64}/bin/aarch64-none-elf-gcc-ar.exe" CACHE STRING "")
    set(CMAKE_RANLIB "${DEVKITA64}/bin/aarch64-none-elf-gcc-ranlib.exe" CACHE STRING "")
else()
    set(CMAKE_C_COMPILER "${DEVKITA64}/bin/aarch64-none-elf-gcc")
    set(CMAKE_CXX_COMPILER "${DEVKITA64}/bin/aarch64-none-elf-g++")
    set(CMAKE_AR "${DEVKITA64}/bin/aarch64-none-elf-gcc-ar" CACHE STRING "")
    set(CMAKE_RANLIB "${DEVKITA64}/bin/aarch64-none-elf-gcc-ranlib" CACHE STRING "")
endif()

set(CMAKE_FIND_ROOT_PATH ${DEVKITA64} ${DEVKITPRO})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)


SET(BUILD_SHARED_LIBS OFF CACHE INTERNAL "Shared libs not available for target")


set(ARCH "-march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft -fPIE -ffunction-sections -D__SWITCH__")
set(CMAKE_C_FLAGS "${ARCH} -fomit-frame-pointer -O2" CACHE STRING "C flags")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -fno-rtti -fno-exceptions" CACHE STRING "C++ flags")
set(CMAKE_EXE_LINKER_FLAGS "-specs=${DEVKITPRO}/libnx/switch.specs ${ARCH}")



