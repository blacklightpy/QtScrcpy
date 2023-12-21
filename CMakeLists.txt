cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
project(all)

include_directories(/home/runner/work/QtScrcpy/x86_64-linux-musl-cross/include)
link_directories(/home/runner/work/QtScrcpy/x86_64-linux-musl-cross/lib)
set(CMAKE_SYSROOT /home/runner/work/QtScrcpy/x86_64-linux-musl-cross)

add_subdirectory(QtScrcpy)
