cmake_minimum_required(VERSION 3.1)
project(NXApplication C)

if(NOT NX)
	message(FATAL_ERROR "This is a NX only project")
endif()

list(APPEND CMAKE_MODULE_PATH $ENV{NXCM_ROOT}/cmake)
find_package(LibNX REQUIRED)	
include(MakeNro)
	
add_executable(switch_application src/main.c)
target_link_libraries(switch_application switch::libnx)
# Make app into a Switch NRO
add_nro_target(switch_application "Switch CMake Application" "modeco80" "1.0.0")