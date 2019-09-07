# Try to find libnx
include(FindPackageHandleStandardArgs)

macro(msys_to_cmake MsysPath ResultingPath)
	if(WIN32)
		# Msys2
		string(REGEX REPLACE "^/([a-zA-Z])/" "\\1:/" ${ResultingPath} "${MsysPath}")
	else()
		# Paths are ok already
		set(${ResultingPath} "${MsysPath}")
	endif()
endmacro()


if(NOT DEVKITPRO)
	msys_to_cmake("$ENV{DEVKITPRO}" DEVKITPRO)
endif()

set(LIBNX_PATHS ${DEVKITPRO}/libnx)

find_path(LIBNX_INCLUDE_DIR switch.h
          PATHS ${LIBNX_PATHS}
          PATH_SUFFIXES include)

find_library(LIBNX_LIBRARY NAMES nx libnx.a
          PATHS ${LIBNX_PATHS}
          PATH_SUFFIXES lib)


set(LIBNX_LIBRARIES ${LIBNX_LIBRARY} )
set(LIBNX_INCLUDE_DIRS ${LIBNX_INCLUDE_DIR} )


find_package_handle_standard_args(LIBNX DEFAULT_MSG
                                  LIBNX_LIBRARY LIBNX_INCLUDE_DIRS)

mark_as_advanced(LIBNX_INCLUDE_DIR LIBNX_LIBRARY)

if(LIBNX_FOUND)
    set(LIBNX ${LIBNX_INCLUDE_DIR}/..)

    add_library(switch::libnx STATIC IMPORTED GLOBAL)
    set_target_properties(switch::libnx PROPERTIES
        IMPORTED_LOCATION "${LIBNX_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${LIBNX_INCLUDE_DIR}"
    )
endif()