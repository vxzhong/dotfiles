@echo off
REM    Copyright 2014 Steve Francia
REM 
REM    Licensed under the Apache License, Version 2.0 (the "License");
REM    you may not use this file except in compliance with the License.
REM    You may obtain a copy of the License at
REM 
REM        http://www.apache.org/licenses/LICENSE-2.0
REM 
REM    Unless required by applicable law or agreed to in writing, software
REM    distributed under the License is distributed on an "AS IS" BASIS,
REM    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
REM    See the License for the specific language governing permissions and
REM    limitations under the License.


@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set DOT_VIM=%HOME%\.vim
@set APP_VIM=%~dp0
IF EXIST "%DOT_VIM%" (
	DEL "%HOME%\_vimrc"
	RD %DOT_VIM%
)

call mklink "%HOME%\_vimrc" "%APP_VIM%\vimrc"
call mklink /J %DOT_VIM% %APP_VIM%

pause