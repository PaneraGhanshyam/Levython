@echo off
REM ============================================================================
REM Levython Simple Build Script
REM ============================================================================
REM
REM Quick and simple build script for Levython on Windows.
REM This is the easiest way to build Levython if you already have:
REM   - A C++ compiler (g++, cl.exe, or clang++)
REM   - OpenSSL libraries installed
REM
REM Motto: Be better than yesterday
REM
REM ============================================================================

setlocal enabledelayedexpansion

REM Set console title and colors
title Levython Simple Build
color 0A

echo.
echo ================================================================================
echo                     LEVYTHON SIMPLE BUILD SCRIPT
echo ================================================================================
echo   Version: 1.0.3
echo   Motto: Be better than yesterday
echo ================================================================================
echo.

REM Determine script and project directories
set SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%
cd /d "%SCRIPT_DIR%\.."
set PROJECT_DIR=%CD%

echo [INFO] Project Directory: %PROJECT_DIR%
echo [INFO] Build Script Directory: %SCRIPT_DIR%
echo.

REM Create directories
if not exist "%PROJECT_DIR%\build" mkdir "%PROJECT_DIR%\build"
if not exist "%PROJECT_DIR%\releases" mkdir "%PROJECT_DIR%\releases"

echo [INFO] Checking for source files...
if not exist "%PROJECT_DIR%\src\levython.cpp" (
    echo [ERROR] Source file not found: src\levython.cpp
    echo [ERROR] Please ensure you are running this from the installer directory.
    echo.
    pause
    exit /b 1
)
echo [OK] Source files found
echo.

REM Detect architecture
echo [INFO] Detecting system architecture...
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set ARCH=x64
    set ARCH_FLAG=-m64
    echo [OK] Detected: 64-bit (x64)
) else if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set ARCH=x86
    set ARCH_FLAG=-m32
    echo [OK] Detected: 32-bit (x86)
) else (
    set ARCH=x64
    set ARCH_FLAG=-m64
    echo [WARN] Unknown architecture, defaulting to x64
)
echo.

REM Try to find compiler
echo [INFO] Searching for C++ compiler...
echo.

REM Check for g++ (MinGW)
where g++ >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Found: g++ ^(MinGW^)
    for /f "tokens=*" %%i in ('g++ --version ^| findstr /r "^[0-9]"') do (
        echo [INFO] Version: %%i
        goto :FOUND_GCC
    )
    :FOUND_GCC
    set COMPILER=gcc
    goto :BUILD
)

REM Check for cl.exe (MSVC)
where cl >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Found: cl.exe ^(MSVC^)
    for /f "tokens=*" %%i in ('cl 2^>^&1 ^| findstr /C:"Version"') do echo [INFO] %%i
    set COMPILER=msvc
    goto :BUILD
)

REM Check for clang++
where clang++ >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Found: clang++ ^(LLVM^)
    for /f "tokens=*" %%i in ('clang++ --version ^| findstr /r "clang"') do echo [INFO] %%i
    set COMPILER=clang
    goto :BUILD
)

REM No compiler found
echo [ERROR] No C++ compiler found!
echo.
echo Please install one of the following:
echo   - MinGW-w64: https://www.mingw-w64.org/
echo   - Visual Studio: https://visualstudio.microsoft.com/
echo   - LLVM/Clang: https://llvm.org/
echo.
pause
exit /b 1

:BUILD
echo.
echo ================================================================================
echo   Building Levython
echo ================================================================================
echo.

set OUTPUT_FILE=%PROJECT_DIR%\releases\levython-windows-%ARCH%.exe

echo [INFO] Compiler: %COMPILER%
echo [INFO] Target Architecture: %ARCH%
echo [INFO] Output: %OUTPUT_FILE%
echo.

REM Try common OpenSSL locations
set OPENSSL_FOUND=0
set OPENSSL_INCLUDE=
set OPENSSL_LIB=

echo [INFO] Searching for OpenSSL...

if defined OPENSSL_DIR (
    if exist "%OPENSSL_DIR%\include\openssl\ssl.h" (
        set OPENSSL_INCLUDE=%OPENSSL_DIR%\include
        set OPENSSL_LIB=%OPENSSL_DIR%\lib
        set OPENSSL_FOUND=1
        echo [OK] Found OpenSSL at: %OPENSSL_DIR%
    )
)

if !OPENSSL_FOUND! EQU 0 (
    if exist "C:\OpenSSL-Win64\include\openssl\ssl.h" (
        set OPENSSL_INCLUDE=C:\OpenSSL-Win64\include
        set OPENSSL_LIB=C:\OpenSSL-Win64\lib
        set OPENSSL_FOUND=1
        echo [OK] Found OpenSSL at: C:\OpenSSL-Win64
    )
)

if !OPENSSL_FOUND! EQU 0 (
    if exist "C:\Program Files\OpenSSL-Win64\include\openssl\ssl.h" (
        set OPENSSL_INCLUDE=C:\Program Files\OpenSSL-Win64\include
        set OPENSSL_LIB=C:\Program Files\OpenSSL-Win64\lib
        set OPENSSL_FOUND=1
        echo [OK] Found OpenSSL at: C:\Program Files\OpenSSL-Win64
    )
)

if !OPENSSL_FOUND! EQU 0 (
    echo [ERROR] OpenSSL not found!
    echo.
    echo Please install OpenSSL:
    echo   1. Download from: https://slproweb.com/products/Win32OpenSSL.html
    echo   2. Install via vcpkg: vcpkg install openssl
    echo   3. Install via Chocolatey: choco install openssl
    echo.
    echo Or set OPENSSL_DIR environment variable to OpenSSL installation path.
    echo.
    pause
    exit /b 1
)

echo [INFO] OpenSSL Include: !OPENSSL_INCLUDE!
echo [INFO] OpenSSL Library: !OPENSSL_LIB!
echo.

echo [INFO] Compiling Levython...
echo.

if "%COMPILER%"=="gcc" (
    echo [BUILD] Using g++ with optimization flags...
    g++ %ARCH_FLAG% -std=c++17 -O3 -DNDEBUG -march=native -static -static-libgcc -static-libstdc++ ^
        -I"!OPENSSL_INCLUDE!" ^
        -L"!OPENSSL_LIB!" ^
        "%PROJECT_DIR%\src\levython.cpp" ^
        -o "%OUTPUT_FILE%" ^
        -lssl -lcrypto -lws2_32 -lcrypt32 -lwinmm -s
) else if "%COMPILER%"=="msvc" (
    echo [BUILD] Using MSVC with optimization flags...
    cl.exe /std:c++17 /O2 /GL /EHsc /DNDEBUG /MT ^
        /I"!OPENSSL_INCLUDE!" ^
        /Fe:"%OUTPUT_FILE%" ^
        "%PROJECT_DIR%\src\levython.cpp" ^
        /link /LTCG /OPT:REF /OPT:ICF ^
        /LIBPATH:"!OPENSSL_LIB!" ^
        libssl.lib libcrypto.lib ws2_32.lib crypt32.lib winmm.lib
) else if "%COMPILER%"=="clang" (
    echo [BUILD] Using clang++ with optimization flags...
    clang++ %ARCH_FLAG% -std=c++17 -O3 -DNDEBUG -march=native -static ^
        -I"!OPENSSL_INCLUDE!" ^
        -L"!OPENSSL_LIB!" ^
        "%PROJECT_DIR%\src\levython.cpp" ^
        -o "%OUTPUT_FILE%" ^
        -lssl -lcrypto -lws2_32 -lcrypt32 -lwinmm
)

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Compilation failed! Exit code: %ERRORLEVEL%
    echo.
    echo Common issues:
    echo   - Missing OpenSSL development libraries
    echo   - Compiler not properly configured
    echo   - Missing system libraries
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================================================
echo                       BUILD COMPLETED SUCCESSFULLY
echo ================================================================================
echo.

if exist "%OUTPUT_FILE%" (
    echo [OK] Executable created: %OUTPUT_FILE%

    REM Get file size
    for %%A in ("%OUTPUT_FILE%") do set SIZE=%%~zA
    set /a SIZE_MB=!SIZE! / 1048576
    echo [OK] File size: !SIZE_MB! MB
    echo.

    echo [INFO] Verifying executable...
    "%OUTPUT_FILE%" --version

    if %ERRORLEVEL% EQU 0 (
        echo [OK] Executable verified successfully!
    ) else (
        echo [WARN] Could not verify executable
    )

    echo.
    echo Quick Start:
    echo   %OUTPUT_FILE% --version
    echo   %OUTPUT_FILE% --help
    echo   %OUTPUT_FILE% script.levy
    echo   %OUTPUT_FILE%  ^(for REPL^)
    echo.
    echo Motto: Be better than yesterday
    echo.
) else (
    echo [ERROR] Executable not found at expected location!
    echo.
)

echo ================================================================================
echo.

pause
endlocal
exit /b 0
