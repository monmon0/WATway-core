cmake_minimum_required(VERSION 3.20)
project(tunnel_traverser)

set(CMAKE_CXX_STANDARD 20)

add_executable(tunnel_traverser main.cpp
        paths.hpp
        paths.cpp
        parse.cpp
        add.cpp
        delete.cpp
        reinit.cpp
        addimage.cpp)
