@echo off
REM ============================================================================
REM Levython Professional Build System - Build All Architectures
REM ============================================================================
REM
REM This script builds Levython installers for all supported architectures.
REM Motto: Be better than yesterday
REM
REM ============================================================================

setlocal enabledelayedexpansion

REM Set console colors and title
title Levython Build System - Building All Architectures
color 0B

echo.
echo ================================================================================
echo                  LEVYTHON PROFESSIONAL BUILD SYSTEM
echo ================================================================================
echo   Building installers for all architectures (x64 + x86)
echo   Version: 1.0.3
echo   Motto: Be better than yesterday
echo ================================================================================
echo.

REM Check for PowerShell
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] PowerShell not found!
    echo [ERROR] PowerShell 5.1 or later is required to run the build system.
    echo.
    pause
    exit /b 1
)

REM Get PowerShell version
for /f "tokens=*" %%i in ('powershell -Command "$PSVersionTable.PSVersion.Major"') do set PS_VERSION=%%i

echo [INFO] PowerShell Version: %PS_VERSION%
echo [INFO] Starting multi-architecture build...
echo.

REM Check if running as administrator
net session >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Running with Administrator privileges
) else (
    echo [WARN] Not running as Administrator - some features may be limited
)
echo.

REM Determine script directory
set SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM Check if Build-Installer.ps1 exists
if not exist "%SCRIPT_DIR%\Build-Installer.ps1" (
    echo [ERROR] Build-Installer.ps1 not found in: %SCRIPT_DIR%
    echo [ERROR] Please ensure all build files are present.
    echo.
    pause
    exit /b 1
)

echo [INFO] Build script found: Build-Installer.ps1
echo [INFO] Build directory: %SCRIPT_DIR%
echo.
echo ================================================================================
echo   Starting Build Process
echo ================================================================================
echo.

REM Execute PowerShell build script with all architectures
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
    "& '%SCRIPT_DIR%\Build-Installer.ps1' -Architecture all"

REM Check exit code
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ================================================================================
    echo                        BUILD COMPLETED SUCCESSFULLY
    echo ================================================================================
    echo.
    echo   All architecture builds have been created successfully!
    echo   Check the releases directory for output files.
    echo.
    echo   Motto: Be better than yesterday
    echo.
    echo ================================================================================
    echo.
) else (
    echo.
    echo ================================================================================
    echo                             BUILD FAILED
    echo ================================================================================
    echo.
    echo   The build process encountered errors. Exit code: %ERRORLEVEL%
    echo   Please review the error messages above for details.
    echo.
    echo   Common issues:
    echo     - Missing C++ compiler (install MinGW-w64 or Visual Studio)
    echo     - Missing OpenSSL libraries (download from slproweb.com)
    echo     - Insufficient disk space
    echo     - Missing dependencies
    echo.
    echo ================================================================================
    echo.
)

REM Pause to see results
pause

endlocal
exit /b %ERRORLEVEL%
