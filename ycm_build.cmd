@echo off

echo aa%VS120COMNTOOLS%aa

call "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat" x86


if exist "%~dp0\bundle\YouCompleteMe\ycm_build" (
 	rd /s /q "%~dp0\bundle\YouCompleteMe\ycm_build"
)
	
mkdir %~dp0\bundle\YouCompleteMe\ycm_build
cd %~dp0\bundle\YouCompleteMe\ycm_build
echo zz%CD%zz
cmake -G "Visual Studio 12" -DPATH_TO_LLVM_ROOT=E:\LLVM %~dp0\bundle\YouCompleteMe\third_party\ycmd\cpp
msbuild /t:ycm_core;ycm_client_support /property:configuration=Release YouCompleteMe.sln
pause