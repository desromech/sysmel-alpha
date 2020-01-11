#!/bin/sh
g++ -shared -Wall `llvm-config --link-shared --cxxflags --libs` -fPIC -o SysmelGCPlugin.so llvm-gc-plugin/SysmelGCPlugin.cpp

