#!/bin/bash

#
# set enviroment for NX compilation
# (For some reason, the devkitA64 compiler does not like being ran out of path)
#

# Set the path to devkitPro and devkitA64 tools
export PATH="${DEVKITPRO}/tools/bin:${DEVKITPRO}/devkitA64/bin:${PATH}"

if [ "${OS}" == "Windows_NT" ]; then
	# Set CMake path on MSYS2, this may not be the same on your machine
	export PATH="/c/Program Files/CMake/bin:${PATH}"
fi
export NXCM_ROOT="$(pwd)";

configure_nx() {
	[[ ! -d "build" ]] && mkdir build
	pushd build
	cmake .. -DCMAKE_TOOLCHAIN_FILE=$NXCM_ROOT/DevkitA64Switch.cmake -G "Unix Makefiles"
	popd
}