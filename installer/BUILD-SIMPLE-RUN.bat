@echo off
REM ============================================================================
REM Levython Simple Build Wrapper
REM ============================================================================
REM This wrapper ensures the window stays open so you can see any errors
REM ============================================================================

title Levython Build - Window will stay open
color 0A

echo.
echo Starting Levython build...
echo Window will remain open after build completes
echo.

REM Run the actual build script in the same window
call "%~dp0BUILD-SIMPLE.bat"

echo.
echo.
echo ============================================================================
echo Build process completed
echo ============================================================================
echo.
pause
