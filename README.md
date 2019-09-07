## nx-cmake
A CMake toolchain and utilities to build Switch homebrew, without needing to maintain seperate build systems.

Usage:

```bash
. <where you cloned>/setenv.sh
cd <insert CMake project here (TIP: Try building one of the sample projects in the repository)>
mkdir build
cd build
nxcmake ..
make
# Profit!
```

The toolchain will automatically declare $NX in CMake so projects can detect NX compilation.

## License
This project is licensed under the MIT License, availiable in LICENSE.
