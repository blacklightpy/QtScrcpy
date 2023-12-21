cmake_minimum_required(VERSION 3.19 FATAL_ERROR)
project(all)

include_directories(${CMAKE_SOURCE_DIR}/../x86_64-linux-musl-cross/include)
link_directories(${CMAKE_SOURCE_DIR}/../x86_64-linux-musl-cross/lib)

add_subdirectory(QtScrcpy)
