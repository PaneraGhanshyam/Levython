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
    goto :END
)
echo [OK] Source files found
echo.

REM Detect architecture
echo [INFO] Detecting system architecture...
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set ARCH=x64
    set ARCH_FLAG=-m64
    echo [OK] Detected: 64-bit
) else if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set ARCH=x86
    set ARCH_FLAG=-m32
    echo [OK] Detected: 32-bit
) else (
    set ARCH=x64
    set ARCH_FLAG=-m64
    echo [WARN] Unknown architecture, defaulting to x64
)
echo.

REM ============================================================================
REM Compiler detection
REM ============================================================================
echo [INFO] Searching for C++ compiler...
echo.

set COMPILER=

where g++ >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo [OK] Found: g++ / MinGW
    set COMPILER=gcc
    goto :FOUND_COMPILER
)

where cl >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo [OK] Found: cl.exe / MSVC
    set COMPILER=msvc
    goto :FOUND_COMPILER
)

where clang++ >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo [OK] Found: clang++ / LLVM
    set COMPILER=clang
    goto :FOUND_COMPILER
)

echo [ERROR] No C++ compiler found!
echo.
echo Please install one of the following:
echo   - MinGW-w64: https://www.mingw-w64.org/
echo   - Visual Studio: https://visualstudio.microsoft.com/
echo   - LLVM/Clang: https://llvm.org/
goto :END

:FOUND_COMPILER
echo.
echo ================================================================================
echo   Building Levython
echo ================================================================================
echo.

set OUTPUT_FILE=%PROJECT_DIR%\releases\levython-windows-%ARCH%.exe

echo [INFO] Compiler: !COMPILER!
echo [INFO] Target Architecture: !ARCH!
echo [INFO] Output: %OUTPUT_FILE%
echo.

REM ============================================================================
REM Smart OpenSSL Detection  (goto-chain to avoid cmd.exe parenthesis bugs)
REM ============================================================================
set OPENSSL_FOUND=0
set OPENSSL_INCLUDE=
set OPENSSL_LIB=
set OPENSSL_BASE=

echo [INFO] Searching for OpenSSL...

REM --- 1. OPENSSL_DIR env var ---
if not defined OPENSSL_DIR goto :SSL_CHK_2
if not exist "%OPENSSL_DIR%\include\openssl\ssl.h" goto :SSL_CHK_2
set "OPENSSL_BASE=%OPENSSL_DIR%"
set "OPENSSL_INCLUDE=%OPENSSL_DIR%\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL via OPENSSL_DIR: %OPENSSL_DIR%
goto :SSL_HEADERS_FOUND

REM --- 2. C:\Program Files\OpenSSL-Win64 (preferred) ---
:SSL_CHK_2
set "SSL_TRY=C:\Program Files\OpenSSL-Win64"
if not exist "!SSL_TRY!\include\openssl\ssl.h" goto :SSL_CHK_3
set "OPENSSL_BASE=!SSL_TRY!"
set "OPENSSL_INCLUDE=!SSL_TRY!\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: !SSL_TRY!
goto :SSL_HEADERS_FOUND

REM --- 3. C:\OpenSSL-Win64 ---
:SSL_CHK_3
if not exist "C:\OpenSSL-Win64\include\openssl\ssl.h" goto :SSL_CHK_4
set "OPENSSL_BASE=C:\OpenSSL-Win64"
set "OPENSSL_INCLUDE=C:\OpenSSL-Win64\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: C:\OpenSSL-Win64
goto :SSL_HEADERS_FOUND

REM --- 4. Scoop user ---
:SSL_CHK_4
if not exist "%USERPROFILE%\scoop\apps\openssl\current\include\openssl\ssl.h" goto :SSL_CHK_5
set "OPENSSL_BASE=%USERPROFILE%\scoop\apps\openssl\current"
set "OPENSSL_INCLUDE=%USERPROFILE%\scoop\apps\openssl\current\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: %USERPROFILE%\scoop\apps\openssl\current
goto :SSL_HEADERS_FOUND

REM --- 5. Scoop global ---
:SSL_CHK_5
if not exist "C:\ProgramData\scoop\apps\openssl\current\include\openssl\ssl.h" goto :SSL_CHK_6
set "OPENSSL_BASE=C:\ProgramData\scoop\apps\openssl\current"
set "OPENSSL_INCLUDE=C:\ProgramData\scoop\apps\openssl\current\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: C:\ProgramData\scoop\apps\openssl\current
goto :SSL_HEADERS_FOUND

REM --- 6. C:\Program Files\OpenSSL ---
:SSL_CHK_6
set "SSL_TRY=C:\Program Files\OpenSSL"
if not exist "!SSL_TRY!\include\openssl\ssl.h" goto :SSL_CHK_7
set "OPENSSL_BASE=!SSL_TRY!"
set "OPENSSL_INCLUDE=!SSL_TRY!\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: !SSL_TRY!
goto :SSL_HEADERS_FOUND

REM --- 7. C:\OpenSSL-Win32 ---
:SSL_CHK_7
if not exist "C:\OpenSSL-Win32\include\openssl\ssl.h" goto :SSL_CHK_8
set "OPENSSL_BASE=C:\OpenSSL-Win32"
set "OPENSSL_INCLUDE=C:\OpenSSL-Win32\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: C:\OpenSSL-Win32
goto :SSL_HEADERS_FOUND

REM --- 8. C:\Program Files (x86)\OpenSSL-Win32 ---
:SSL_CHK_8
set "SSL_TRY=C:\Program Files (x86)\OpenSSL-Win32"
if not exist "!SSL_TRY!\include\openssl\ssl.h" goto :SSL_CHK_9
set "OPENSSL_BASE=!SSL_TRY!"
set "OPENSSL_INCLUDE=!SSL_TRY!\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: !SSL_TRY!
goto :SSL_HEADERS_FOUND

REM --- 9. C:\Program Files (x86)\OpenSSL ---
:SSL_CHK_9
set "SSL_TRY=C:\Program Files (x86)\OpenSSL"
if not exist "!SSL_TRY!\include\openssl\ssl.h" goto :SSL_CHK_10
set "OPENSSL_BASE=!SSL_TRY!"
set "OPENSSL_INCLUDE=!SSL_TRY!\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: !SSL_TRY!
goto :SSL_HEADERS_FOUND

REM --- 10. vcpkg x64 ---
:SSL_CHK_10
if not exist "C:\vcpkg\installed\x64-windows\include\openssl\ssl.h" goto :SSL_CHK_11
set "OPENSSL_BASE=C:\vcpkg\installed\x64-windows"
set "OPENSSL_INCLUDE=C:\vcpkg\installed\x64-windows\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: C:\vcpkg\installed\x64-windows
goto :SSL_HEADERS_FOUND

REM --- 11. vcpkg x86 ---
:SSL_CHK_11
if not exist "C:\vcpkg\installed\x86-windows\include\openssl\ssl.h" goto :SSL_CHK_12
set "OPENSSL_BASE=C:\vcpkg\installed\x86-windows"
set "OPENSSL_INCLUDE=C:\vcpkg\installed\x86-windows\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: C:\vcpkg\installed\x86-windows
goto :SSL_HEADERS_FOUND

REM --- 12. MSYS2 mingw64 ---
:SSL_CHK_12
if not exist "C:\msys64\mingw64\include\openssl\ssl.h" goto :SSL_CHK_13
set "OPENSSL_BASE=C:\msys64\mingw64"
set "OPENSSL_INCLUDE=C:\msys64\mingw64\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: C:\msys64\mingw64
goto :SSL_HEADERS_FOUND

REM --- 13. MSYS2 ucrt64 ---
:SSL_CHK_13
if not exist "C:\msys64\ucrt64\include\openssl\ssl.h" goto :SSL_CHK_14
set "OPENSSL_BASE=C:\msys64\ucrt64"
set "OPENSSL_INCLUDE=C:\msys64\ucrt64\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: C:\msys64\ucrt64
goto :SSL_HEADERS_FOUND

REM --- 14. MSYS2 mingw32 ---
:SSL_CHK_14
if not exist "C:\msys64\mingw32\include\openssl\ssl.h" goto :SSL_NOT_FOUND
set "OPENSSL_BASE=C:\msys64\mingw32"
set "OPENSSL_INCLUDE=C:\msys64\mingw32\include"
set OPENSSL_FOUND=1
echo [OK] Found OpenSSL at: C:\msys64\mingw32
goto :SSL_HEADERS_FOUND

:SSL_NOT_FOUND
echo [ERROR] OpenSSL not found!
echo.
echo Searched in:
echo   - OPENSSL_DIR env variable
echo   - Scoop user + global
echo   - C:\Program Files\OpenSSL-Win64
echo   - C:\OpenSSL-Win64 / C:\OpenSSL-Win32
echo   - C:\Program Files\OpenSSL
echo   - C:\Program Files x86 \OpenSSL-Win32
echo   - C:\vcpkg\installed\x64-windows / x86-windows
echo   - C:\msys64\mingw64, ucrt64, mingw32
echo.
echo Please install OpenSSL or set OPENSSL_DIR environment variable.
echo   Download: https://slproweb.com/products/Win32OpenSSL.html
goto :END

REM ============================================================================
REM Smart library path detection  (goto-chain for same reason)
REM ============================================================================
:SSL_HEADERS_FOUND
echo [INFO] Resolving OpenSSL library path...

set "OPENSSL_LIB_BASE=!OPENSSL_BASE!\lib"

REM --- VC\x64\MT ---
if not "!ARCH!"=="x64" goto :LIB_CHK_X86
if not exist "!OPENSSL_LIB_BASE!\VC\x64\MT\libssl.lib" goto :LIB_CHK_X64_MD
set "OPENSSL_LIB=!OPENSSL_LIB_BASE!\VC\x64\MT"
echo [OK] Found libs: VC\x64\MT - static
goto :OPENSSL_DONE

:LIB_CHK_X64_MD
if not exist "!OPENSSL_LIB_BASE!\VC\x64\MD\libssl.lib" goto :LIB_CHK_X64_MTD
set "OPENSSL_LIB=!OPENSSL_LIB_BASE!\VC\x64\MD"
echo [OK] Found libs: VC\x64\MD - dynamic
goto :OPENSSL_DONE

:LIB_CHK_X64_MTD
if not exist "!OPENSSL_LIB_BASE!\VC\x64\MTd\libssl.lib" goto :LIB_CHK_X64_MDD
set "OPENSSL_LIB=!OPENSSL_LIB_BASE!\VC\x64\MTd"
echo [OK] Found libs: VC\x64\MTd - static debug
goto :OPENSSL_DONE

:LIB_CHK_X64_MDD
if not exist "!OPENSSL_LIB_BASE!\VC\x64\MDd\libssl.lib" goto :LIB_CHK_DIRECT
set "OPENSSL_LIB=!OPENSSL_LIB_BASE!\VC\x64\MDd"
echo [OK] Found libs: VC\x64\MDd - dynamic debug
goto :OPENSSL_DONE

:LIB_CHK_X86
if not exist "!OPENSSL_LIB_BASE!\VC\x86\MT\libssl.lib" goto :LIB_CHK_WIN32_MT
set "OPENSSL_LIB=!OPENSSL_LIB_BASE!\VC\x86\MT"
echo [OK] Found libs: VC\x86\MT - static
goto :OPENSSL_DONE

:LIB_CHK_WIN32_MT
if not exist "!OPENSSL_LIB_BASE!\VC\Win32\MT\libssl.lib" goto :LIB_CHK_X86_MD
set "OPENSSL_LIB=!OPENSSL_LIB_BASE!\VC\Win32\MT"
echo [OK] Found libs: VC\Win32\MT - static
goto :OPENSSL_DONE

:LIB_CHK_X86_MD
if not exist "!OPENSSL_LIB_BASE!\VC\x86\MD\libssl.lib" goto :LIB_CHK_DIRECT
set "OPENSSL_LIB=!OPENSSL_LIB_BASE!\VC\x86\MD"
echo [OK] Found libs: VC\x86\MD - dynamic
goto :OPENSSL_DONE

REM --- Direct lib\ ---
:LIB_CHK_DIRECT
if not exist "!OPENSSL_LIB_BASE!\libssl.lib" goto :LIB_CHK_STATIC_A
set "OPENSSL_LIB=!OPENSSL_LIB_BASE!"
echo [OK] Found libs in: lib\ .lib
goto :OPENSSL_DONE

:LIB_CHK_STATIC_A
if not exist "!OPENSSL_LIB_BASE!\libssl.a" goto :LIB_CHK_DLL_A
set "OPENSSL_LIB=!OPENSSL_LIB_BASE!"
echo [OK] Found libs in: lib\ .a static
goto :OPENSSL_DONE

:LIB_CHK_DLL_A
if not exist "!OPENSSL_LIB_BASE!\libssl.dll.a" goto :LIB_NOT_FOUND
set "OPENSSL_LIB=!OPENSSL_LIB_BASE!"
echo [OK] Found libs in: lib\ .dll.a import
goto :OPENSSL_DONE

:LIB_NOT_FOUND
echo [ERROR] OpenSSL headers found at: !OPENSSL_BASE!
echo [ERROR] But no library files found in: !OPENSSL_LIB_BASE!
echo [ERROR] Checked: lib\, lib\VC\x64\MT, lib\VC\x64\MD, etc.
goto :END

REM ============================================================================
REM Compile
REM ============================================================================
:OPENSSL_DONE
echo [INFO] OpenSSL Include: !OPENSSL_INCLUDE!
echo [INFO] OpenSSL Library: !OPENSSL_LIB!
echo.

echo [INFO] Compiling Levython...
echo.

if "!COMPILER!"=="gcc" goto :COMPILE_GCC
if "!COMPILER!"=="msvc" goto :COMPILE_MSVC
if "!COMPILER!"=="clang" goto :COMPILE_CLANG
echo [ERROR] Unknown compiler: !COMPILER!
goto :END

:COMPILE_GCC
echo [BUILD] Using g++ with optimization flags...

REM ---------------------------------------------------------------------------
REM Sanity check: verify that the MinGW/WinLibs toolchain has proper C headers.
REM If wchar.h / stdlib.h are missing, g++ will fail deep inside <cwchar>/<cstdlib>
REM with "fatal error: wchar.h: No such file or directory" or similar.
REM ---------------------------------------------------------------------------
set "__LEVY_STDCHK=%PROJECT_DIR%\build\__levy_stdcheck.cpp"
> "%__LEVY_STDCHK%" echo #include ^<wchar.h^>
>>"%__LEVY_STDCHK%" echo #include ^<stdlib.h^>
>>"%__LEVY_STDCHK%" echo int main() { return 0; }
g++ -c "%__LEVY_STDCHK%" -o "%PROJECT_DIR%\build\__levy_stdcheck.o" >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo [ERROR] Your g++ / MinGW installation is missing required C runtime headers.
    echo [ERROR] Headers like ^<wchar.h^> and ^<stdlib.h^> must be present for C++ to compile.
    echo [ERROR] This indicates a broken or partial MinGW/WinLibs install, not a Levython source bug.
    echo.
    echo [HINT] Recommended options:
    echo   - Install w64devkit or MSYS2 MinGW-w64 as described in BUILD.md
    echo   - Or repair/reinstall your existing MinGW so that standard headers are available
    echo   - Then re-run this script from the correct developer shell
    del /q "%__LEVY_STDCHK%" 2>nul
    del /q "%PROJECT_DIR%\build\__levy_stdcheck.o" 2>nul
    goto :END
)
del /q "%__LEVY_STDCHK%" 2>nul
del /q "%PROJECT_DIR%\build\__levy_stdcheck.o" 2>nul

REM Generate MinGW-compatible OpenSSL import libs in a dedicated arch-specific directory.
REM This avoids stale/incompatible build\libssl.a files from older toolchains.
set "MINGW_SSL_LIB_DIR=%PROJECT_DIR%\build\mingw-openssl-!ARCH!"
if not exist "!MINGW_SSL_LIB_DIR!" mkdir "!MINGW_SSL_LIB_DIR!" >nul 2>&1

if "!ARCH!"=="x64" (
    set "SSL_DLL_PATH=!OPENSSL_BASE!\bin\libssl-3-x64.dll"
    set "CRYPTO_DLL_PATH=!OPENSSL_BASE!\bin\libcrypto-3-x64.dll"
) else (
    set "SSL_DLL_PATH=!OPENSSL_BASE!\bin\libssl-3.dll"
    set "CRYPTO_DLL_PATH=!OPENSSL_BASE!\bin\libcrypto-3.dll"
)

if not exist "!SSL_DLL_PATH!" set "SSL_DLL_PATH=!OPENSSL_BASE!\bin\libssl-3.dll"
if not exist "!CRYPTO_DLL_PATH!" set "CRYPTO_DLL_PATH=!OPENSSL_BASE!\bin\libcrypto-3.dll"

if exist "!SSL_DLL_PATH!" (
    if exist "!CRYPTO_DLL_PATH!" (
        pushd "!MINGW_SSL_LIB_DIR!"
        set "NEED_MINGW_IMPORT_GEN=1"
        set "HAS_SSL_A=0"
        set "HAS_CRYPTO_A=0"
        if exist "libssl.a" set "HAS_SSL_A=1"
        if exist "libcrypto.a" set "HAS_CRYPTO_A=1"
        if "!HAS_SSL_A!!HAS_CRYPTO_A!"=="11" (
            set "NEED_MINGW_IMPORT_GEN=0"
            echo [INFO] Reusing cached MinGW OpenSSL import libraries.
        )
        if "!NEED_MINGW_IMPORT_GEN!"=="1" (
            echo [INFO] Creating MinGW import libraries from OpenSSL DLLs...
            echo [INFO] Note: libcrypto import generation may take a few minutes on first build.

            where gendef >nul 2>&1
            if !ERRORLEVEL! NEQ 0 (
                echo [WARN] gendef not found. Skipping DLL import generation.
            ) else (
                where dlltool >nul 2>&1
                if !ERRORLEVEL! NEQ 0 (
                    echo [WARN] dlltool not found. Skipping DLL import generation.
                ) else (
                    for %%F in ("!SSL_DLL_PATH!") do set "SSL_DLL_NAME=%%~nxF"
                    for %%F in ("!CRYPTO_DLL_PATH!") do set "CRYPTO_DLL_NAME=%%~nxF"

                    set "SSL_DEF_NAME=libssl-3.def"
                    set "CRYPTO_DEF_NAME=libcrypto-3.def"
                    if /I "!SSL_DLL_NAME!"=="libssl-3-x64.dll" set "SSL_DEF_NAME=libssl-3-x64.def"
                    if /I "!CRYPTO_DLL_NAME!"=="libcrypto-3-x64.dll" set "CRYPTO_DEF_NAME=libcrypto-3-x64.def"

                    if not exist "libssl.a" (
                        echo [INFO] Generating libssl.a...
                        del /q "!SSL_DEF_NAME!" >nul 2>&1
                        gendef "!SSL_DLL_PATH!" >nul 2>&1
                        if exist "!SSL_DEF_NAME!" dlltool -d "!SSL_DEF_NAME!" -D "!SSL_DLL_NAME!" -l libssl.a >nul 2>&1
                    )

                    if not exist "libcrypto.a" (
                        echo [INFO] Generating libcrypto.a - this is the slow step...
                        del /q "!CRYPTO_DEF_NAME!" >nul 2>&1
                        gendef "!CRYPTO_DLL_PATH!" >nul 2>&1
                        if exist "!CRYPTO_DEF_NAME!" dlltool -d "!CRYPTO_DEF_NAME!" -D "!CRYPTO_DLL_NAME!" -l libcrypto.a >nul 2>&1
                    )
                )
            )
        )
        popd
    )
)

REM Use explicit arch flag and static-link the C++ runtime to avoid CRT DLL issues
g++ !ARCH_FLAG! -std=c++17 -O3 -DNDEBUG -DINITGUID -static-libstdc++ -static-libgcc ^
    -I"!OPENSSL_INCLUDE!" -L"!MINGW_SSL_LIB_DIR!" -L"!OPENSSL_LIB!" ^
    "%PROJECT_DIR%\src\levython.cpp" "%PROJECT_DIR%\src\http_client.cpp" ^
    -o "%OUTPUT_FILE%" ^
    -lssl -lcrypto -lws2_32 -lcrypt32 -lole32 -lwinmm -loleaut32 -luuid -lgdi32 -lpropsys
goto :CHECK_BUILD

:COMPILE_MSVC
echo [BUILD] Using MSVC with optimization flags...
set "SOURCES=%PROJECT_DIR%\src\levython.cpp %PROJECT_DIR%\src\http_client.cpp"
cl.exe /std:c++17 /O2 /GL /EHsc /DNDEBUG /MT /I"!OPENSSL_INCLUDE!" /Fe:"%OUTPUT_FILE%" !SOURCES! /link /LTCG /OPT:REF /OPT:ICF /LIBPATH:"!OPENSSL_LIB!" libssl.lib libcrypto.lib ws2_32.lib crypt32.lib gdi32.lib winmm.lib ole32.lib oleaut32.lib uuid.lib
goto :CHECK_BUILD

:COMPILE_CLANG
echo [BUILD] Using clang++ with optimization flags...
set "SOURCES=%PROJECT_DIR%\src\levython.cpp %PROJECT_DIR%\src\http_client.cpp"
set "SYSLIBS=-lws2_32 -lcrypt32 -lgdi32 -lwinmm -lole32 -loleaut32 -luuid -lpropsys -lucrt"
clang++ !ARCH_FLAG! -std=c++17 -O3 -DNDEBUG -march=native -static -I"!OPENSSL_INCLUDE!" -L"!OPENSSL_LIB!" !SOURCES! -o "%OUTPUT_FILE%" -lssl -lcrypto !SYSLIBS!
goto :CHECK_BUILD

:CHECK_BUILD
if !ERRORLEVEL! NEQ 0 (
    echo.
    echo [ERROR] Compilation failed! Exit code: !ERRORLEVEL!
    echo.
    echo Common issues:
    echo   - Missing OpenSSL development libraries
    echo   - Compiler not properly configured
    echo   - Missing system libraries
    goto :END
)

echo.
echo ================================================================================
echo                       BUILD COMPLETED SUCCESSFULLY
echo ================================================================================
echo.

if not exist "%OUTPUT_FILE%" (
    echo [ERROR] Executable not found at expected location!
    goto :END
)

echo [OK] Executable created: %OUTPUT_FILE%

REM Get file size
for %%A in ("%OUTPUT_FILE%") do set SIZE=%%~zA
set /a SIZE_MB=!SIZE! / 1048576
echo [OK] File size: !SIZE_MB! MB
echo.

echo [INFO] Verifying executable...
"%OUTPUT_FILE%" --version

echo.
echo Quick Start:
echo   %OUTPUT_FILE% --version
echo   %OUTPUT_FILE% --help
echo   %OUTPUT_FILE% script.levy
echo.
echo Motto: Be better than yesterday

echo ================================================================================

:END
echo.
echo Press any key to exit...
pause >nul
endlocal
