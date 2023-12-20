echo ---------------------------------------------------------------
echo Check \& Set Environment Variables
echo ---------------------------------------------------------------

# Get Qt path
# ENV_QT_PATH example: /home/barry/Qt5.9.6/5.9.6
echo Current ENV_QT_PATH: $ENV_QT_PATH
echo Current directory: $(pwd)
# Set variables
qt_cmake_path=$ENV_QT_PATH/gcc_64/lib/cmake/Qt5
export PATH=$qt_gcc_path/bin:$PATH

#export CC="musl-gcc -static -Os"
set -euo pipefail
# musl paths
MUSL_PREFIX='/usr/local/x86_64-linux-musl'
MUSL_INC="$MUSL_PREFIX/include"
MUSL_LIB="$MUSL_PREFIX/lib"
CC='/usr/local/bin/x86_64-linux-musl-gcc'
CXX='/usr/local/bin/x86_64-linux-musl-g++'

# Remember working directory
old_cd=$(pwd)

# Set working dir to the script's path
cd $(dirname "$0")/.../

echo
echo
echo ---------------------------------------------------------------
echo Check Build Parameters
echo ---------------------------------------------------------------
echo Possible build modes: Debug/Release/MinSizeRel/RelWithDebInfo

build_mode="$1"
if [[ $build_mode != "Release" && $build_mode != "Debug" && $build_mode != "MinSizeRel" && $build_mode != "RelWithDebInfo" ]]; then
    echo "error: unknown build mode, exiting......"
    exit 1
fi

echo Current build mode: $build_mode

echo
echo
echo ---------------------------------------------------------------
echo CMake Build Begins
echo ---------------------------------------------------------------

# Remove output folder
output_path=./output
if [ -d "$output_path" ]; then
    rm -rf $output_path
fi


cmake_params="-DCMAKE_PREFIX_PATH=$qt_cmake_path -DCMAKE_BUILD_TYPE=$build_mode -DCMAKE_C_FLAGS="-static -Os""
CC="$CC"                        \
CXX="$CXX"                      \
LDFLAGS="-L$MUSL_LIB -Wl,-rpath,$MUSL_LIB"      \
CFLAGS="-I$MUSL_INC"                    \
CXXFLAGS="-I$MUSL_INC"                  \
CPPFLAGS="-I$MUSL_INC"                  \
CMAKE_PREFIX_PATH="$MUSL_PREFIX"            \
cmake $cmake_params .

if [ $? -ne 0 ] ;then
    echo "error: CMake failed, exiting......"
    exit 1
fi

CC="$CC"                        \
CXX="$CXX"                      \
LDFLAGS="-L$MUSL_LIB -Wl,-rpath,$MUSL_LIB"      \
CFLAGS="-I$MUSL_INC"                    \
CXXFLAGS="-I$MUSL_INC"                  \
CPPFLAGS="-I$MUSL_INC"                  \
CMAKE_PREFIX_PATH="$MUSL_PREFIX"            \
cmake --build . --config "$build_mode" -j8

if [ $? -ne 0 ] ;then
    echo "error: CMake build failed, exiting......"
    exit 1
fi

echo
echo
echo ---------------------------------------------------------------
echo CMake Build Succeeded
echo ---------------------------------------------------------------

# Resume current directory
cd $old_cd
exit 0
