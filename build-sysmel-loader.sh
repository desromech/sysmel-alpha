#!/bin/sh
exec gcc -Wall -g -o sysmel-loader sylsif/sysmel-loader.c -lpthread -ldl
