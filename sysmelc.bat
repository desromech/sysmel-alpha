@echo off
SET top=%~dp0
%top%pharo-vm/PharoConsole.exe --headless sysmel.image sysmelc %*
