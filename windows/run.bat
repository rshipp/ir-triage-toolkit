@echo off
rem Collect data.

rem Make sure we're Admin.
net file >nul 2>nul
if errorlevel 1 (
        echo Must be Admin!
        pause >nul
        goto :eof
)

rem Where should we store the data?

