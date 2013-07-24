@echo off
rem create-toolkit.bat
rem Create an incident response and volatile data collection toolkit for
rem use on Windows machines.

if "%1"=="" (
	set /p saveto=Directory to save toolkit: 
) else (
	set saveto=%1
)

mkdir "%saveto%"

if not exist "%saveto%\" (
	echo No save directory specified, or invalid directory.
	echo Press any key to exit...
	pause >nul 2>nul
	goto :eof
)

if not exist windows\run.bat (
	echo Toolkit files cannot be found.
	echo Press any key to exit...
	pause >nul 2>nul
	goto :eof
)

rem Install the local toolkit files
copy windows\ "%saveto%\"

rem Download/Install Memoryze
windows\bin\wget.exe http://www.mandiant.com/library/MemoryzeSetup3.0.msi
msiexec /a MemoryzeSetup3.0.msi /qb TARGETDIR="%saveto%\bin\memoryze"
