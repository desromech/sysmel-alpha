#!/bin/sh
g++ -shared `llvm-config --link-shared --cxxflags --libs` -Wall -o SysmelGCPlugin.so llvm-gc-plugin/SysmelGCPlugin.cpp

