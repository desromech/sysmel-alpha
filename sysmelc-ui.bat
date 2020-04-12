@echo off
SET top=%~dp0
%top%pharo-vm/Pharo.exe sysmel.image --interactive sysmelc %*
