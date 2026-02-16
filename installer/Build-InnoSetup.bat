@echo off
REM ============================================================================
REM Levython - Build Inno Setup Installer
REM ============================================================================
REM
REM This script creates a professional Windows installer using Inno Setup.
REM Requires: Inno Setup 6.x installed on your system
REM
REM Motto: Be better than yesterday
REM
REM ============================================================================

setlocal enabledelayedexpansion

REM Set console appearance
title Levython - Building Installer
color 0B

echo.
echo ================================================================================
echo            LEVYTHON INSTALLER BUILD SYSTEM
echo ================================================================================
echo   Creating Windows installer with enhanced UI/UX
echo   Version: 1.0.3
echo   Motto: Be better than yesterday
echo ================================================================================
echo.

REM Determine directories
set SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%
set PROJECT_DIR=%SCRIPT_DIR%\..
set ISS_FILE=%SCRIPT_DIR%\levython-setup.iss
set RELEASES_DIR=%PROJECT_DIR%\releases

echo [INFO] Project Directory: %PROJECT_DIR%
echo [INFO] Installer Script: %ISS_FILE%
echo [INFO] Output Directory: %RELEASES_DIR%
echo.

REM Check if ISS file exists
if not exist "%ISS_FILE%" (
    echo [ERROR] Inno Setup script not found!
    echo [ERROR] Expected location: %ISS_FILE%
    echo.
    pause
    exit /b 1
)
echo [OK] Inno Setup script found
echo.

REM Search for Inno Setup Compiler (ISCC.exe)
echo [INFO] Searching for Inno Setup Compiler...
echo.

set ISCC_PATH=
set ISCC_FOUND=0

REM Check common installation paths
set PATHS[0]="%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
set PATHS[1]="%ProgramFiles%\Inno Setup 6\ISCC.exe"
set PATHS[2]="%ProgramFiles(x86)%\Inno Setup 5\ISCC.exe"
set PATHS[3]="%ProgramFiles%\Inno Setup 5\ISCC.exe"

for /L %%i in (0,1,3) do (
    set "CURRENT_PATH=!PATHS[%%i]!"
    set CURRENT_PATH=!CURRENT_PATH:"=!

    if exist "!CURRENT_PATH!" (
        set ISCC_PATH=!CURRENT_PATH!
        set ISCC_FOUND=1
        echo [OK] Found Inno Setup Compiler
        echo [INFO] Location: !CURRENT_PATH!

        REM Get version
        for /f "tokens=*" %%v in ('"!CURRENT_PATH!" /? 2^>^&1 ^| findstr /C:"Inno Setup"') do (
            echo [INFO] %%v
        )
        goto :FOUND_ISCC
    )
)

:FOUND_ISCC
if !ISCC_FOUND! EQU 0 (
    echo [ERROR] Inno Setup Compiler not found!
    echo.
    echo Please install Inno Setup 6:
    echo   Download from: https://jrsoftware.org/isdl.php
    echo   Install Location: C:\Program Files ^(x86^)\Inno Setup 6
    echo.
    echo After installation, run this script again.
    echo.
    pause
    exit /b 1
)
echo.

REM Check for required files
echo [INFO] Checking for required files...
echo.

set MISSING_FILES=0

REM Check for icon
if exist "%PROJECT_DIR%\icon.png" (
    echo [OK] Logo/Icon found: icon.png
) else (
    echo [WARN] Logo/Icon not found: icon.png
    echo [WARN] Installer will be created without custom icon
)

REM Check for LICENSE
if exist "%PROJECT_DIR%\LICENSE" (
    echo [OK] License file found
) else (
    echo [WARN] LICENSE file not found
    set /a MISSING_FILES+=1
)

REM Check for README
if exist "%PROJECT_DIR%\README.md" (
    echo [OK] README.md found
) else (
    echo [WARN] README.md not found
    set /a MISSING_FILES+=1
)

REM Check for executables
set EXE_FOUND=0
if exist "%RELEASES_DIR%\levython-windows-x64.exe" (
    echo [OK] x64 executable found
    set /a EXE_FOUND+=1
)
if exist "%RELEASES_DIR%\levython-windows-x86.exe" (
    echo [OK] x86 executable found
    set /a EXE_FOUND+=1
)
if exist "%RELEASES_DIR%\levython-windows-arm64.exe" (
    echo [OK] ARM64 executable found
    set /a EXE_FOUND+=1
)

if !EXE_FOUND! EQU 0 (
    echo [ERROR] No executables found in releases directory!
    echo [ERROR] Please build Levython first using Build-Installer.ps1 or BUILD-SIMPLE.bat
    echo.
    pause
    exit /b 1
)

echo.
echo [INFO] Found !EXE_FOUND! architecture executable^(s^)
echo.

REM Create releases directory if it doesn't exist
if not exist "%RELEASES_DIR%" (
    echo [INFO] Creating releases directory...
    mkdir "%RELEASES_DIR%"
)

echo ================================================================================
echo   Building Installer with Inno Setup
echo ================================================================================
echo.

REM Build the installer
echo [BUILD] Compiling installer script...
echo [BUILD] This may take a minute...
echo.

"%ISCC_PATH%" "%ISS_FILE%"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ================================================================================
    echo                           BUILD FAILED
    echo ================================================================================
    echo.
    echo [ERROR] Inno Setup compilation failed! Exit code: %ERRORLEVEL%
    echo.
    echo Common issues:
    echo   - Missing source files referenced in the .iss script
    echo   - Syntax errors in levython-setup.iss
    echo   - Missing dependencies
    echo   - Insufficient permissions
    echo.
    echo Please review the error messages above for details.
    echo.
    echo ================================================================================
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================================================
echo                     BUILD COMPLETED SUCCESSFULLY
echo ================================================================================
echo.

REM Find and display the created installer
set INSTALLER_FILE=%RELEASES_DIR%\levython-1.0.3-windows-setup.exe

if exist "%INSTALLER_FILE%" (
    echo [OK] Professional installer created successfully!
    echo.
    echo [INFO] Installer Details:
    echo   File: %INSTALLER_FILE%

    REM Get file size
    for %%A in ("%INSTALLER_FILE%") do (
        set SIZE=%%~zA
        set /a SIZE_MB=!SIZE! / 1048576
        echo   Size: !SIZE_MB! MB ^(!SIZE! bytes^)
    )

    echo.
    echo [INFO] Installer Features:
    echo   - Modern Windows 11/10 UI with custom branding
    echo   - Automatic architecture detection
    echo   - Integrated logo throughout installation
    echo   - Multi-language support
    echo   - Enhanced UI/UX
    echo   - PATH configuration
    echo   - File associations ^(.levy, .ly^)
    echo   - VS Code extension installation
    echo.
    echo [INFO] Installation Options:
    echo   GUI Mode:    "%INSTALLER_FILE%"
    echo   Silent Mode: "%INSTALLER_FILE%" /VERYSILENT /NORESTART
    echo.
    echo Motto: Be better than yesterday
    echo.
) else (
    echo [WARN] Installer file not found at expected location.
    echo [INFO] Check releases directory for output files:
    dir /b "%RELEASES_DIR%\*.exe"
    echo.
)

echo ================================================================================
echo.

REM Ask if user wants to open releases folder
set /p OPEN_FOLDER="Open releases folder? (Y/N): "
if /i "!OPEN_FOLDER!"=="Y" (
    start "" explorer.exe "%RELEASES_DIR%"
)

echo.
echo Thank you for building Levython!
echo.
pause

endlocal
exit /b 0
