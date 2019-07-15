cmake_minimum_required(VERSION 3.1)
project(NXAndPC C)

if(NX)
	# NX compilation
	list(APPEND CMAKE_MODULE_PATH $ENV{NXCM_ROOT}/cmake)
	find_package(LibNX REQUIRED)
	
	include(MakeNro)
	
	
	add_executable(app src/main.c)
	target_link_libraries(app switch::libnx)
	# Make app into a Switch NRO
	add_nro_target(app "Switch CMake Application (NX & PC)" "modeco80" "1.0.0")
else()
	# PC compilation
	add_executable(app src/main.c)
endif()