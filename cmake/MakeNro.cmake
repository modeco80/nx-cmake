# 
# Make a NRO from a compiled ELF target
# (TODO: Support ROMFS?)
#

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

if(NOT ELF2NRO)
	find_program(ELF2NRO elf2nro ${DEVKITPRO}/tools/bin)
	if(ELF2NRO)
		message(STATUS "elf2nro found at ${ELF2NRO}")
	else()
		message(STATUS "elf2nro not found")
	endif()
endif()	


if(NOT NACPTOOL)
	find_program(NACPTOOL nacptool ${DEVKITPRO}/tools/bin)
	if(NACPTOOL)
		message(STATUS "nacptool found at ${NACPTOOL}")
	else()
		message(STATUS "nacptool not found")
	endif()
endif()	

function(__add_nacp target APP_TITLE APP_AUTHOR APP_VERSION)
	if(NACPTOOL)
        set(__NACP_COMMAND ${NACPTOOL} --create "${APP_TITLE}" "${APP_AUTHOR}" "${APP_VERSION}" ${CMAKE_CURRENT_BINARY_DIR}/${target})
    endif()
    add_custom_command( OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target}
                        COMMAND ${__NACP_COMMAND}
                        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
                        VERBATIM
						COMMENT "Making NACP ${target}"
    )
endfunction()

# TODO(modeco80): elf2nro has --romfsdir= maybe we could use that to do romfs
function(add_nro_target target)
	get_filename_component(target_we ${target} NAME_WE)
	if((NOT (${ARGC} GREATER 1 AND "${ARGV1}" STREQUAL "NO_NACP") ) OR (${ARGC} GREATER 3) )
        if(${ARGC} GREATER 3)
            set(APP_TITLE ${ARGV1})
            set(APP_AUTHOR ${ARGV2})
            set(APP_VERSION ${ARGV3})
        endif()
		
        if(${ARGC} EQUAL 4)
            set(APP_ICON ${ARGV4})
        endif()
		
        if(NOT APP_TITLE)
            set(APP_TITLE ${target})
        endif()
		
		
        if(NOT APP_AUTHOR)
            set(APP_AUTHOR "Unspecified Author")
        endif()
		
        if(NOT APP_ICON)
            if(EXISTS ${target}.png)
                set(APP_ICON ${target}.png)
            elseif(EXISTS icon.png)
                set(APP_ICON icon.png)
            elseif(LIBNX)
                set(APP_ICON ${DEVKITPRO}/libnx/default_icon.jpg)
            else()
                message(FATAL_ERROR "No icon found! Please use NO_NACP or provide a icon.")
            endif()
        endif()
		
        if( NOT ${target_we}.nacp)
            __add_nacp(${target_we}.nacp ${APP_TITLE} ${APP_AUTHOR} ${APP_VERSION})
        endif()
		
		if(APP_ICON)
        add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nro
                            COMMAND ${ELF2NRO} $<TARGET_FILE:${target}> ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nro --nacp=${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nacp
                            DEPENDS ${target} ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nacp
                            VERBATIM
							COMMENT "Converting ${target} to ${target}.nro"
        )
		else()
		     add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nro
                            COMMAND ${ELF2NRO} $<TARGET_FILE:${target}> ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nro --icon=${APP_ICON} --nacp=${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nacp
                            DEPENDS ${target} ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nacp
                            VERBATIM
							COMMENT "Converting ${target} to ${target}.nro"
			)
		endif()
    else()
        message(STATUS "No nacp file will be generated")
        add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.3dsx
                            COMMAND ${ELF2NRO} $<TARGET_FILE:${target}> ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nro
                            DEPENDS ${target}
                            VERBATIM
							COMMENT "Converting ${target} to ${target}.nro"
        )
    endif()
    add_custom_target(${target_we}_nro ALL SOURCES ${CMAKE_CURRENT_BINARY_DIR}/${target_we}.nro)
endfunction()
	