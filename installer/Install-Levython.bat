@echo off
REM ============================================================================
REM Levython Windows Installer - Interactive Launcher
REM ============================================================================
REM
REM This script provides an easy-to-use interface for installing Levython.
REM It will launch the PowerShell installer with a beautiful UI.
REM
REM Usage: Simply double-click this file or run from command prompt
REM
REM Motto: Be better than yesterday
REM
REM ============================================================================

setlocal enabledelayedexpansion

REM Set console appearance
title Levython Installer - Welcome
color 0B

REM Check if running as administrator
net session >nul 2>&1
set IS_ADMIN=%ERRORLEVEL%

cls
echo.
echo ================================================================================
echo                         LEVYTHON INSTALLER
echo ================================================================================
echo.
echo                   High Performance Programming Language
echo                   Version: 1.0.3
echo.
echo                   Motto: Be better than yesterday
echo.
echo ================================================================================
echo.

REM Display admin status
if %IS_ADMIN% EQU 0 (
    echo [OK] Running with Administrator privileges
) else (
    echo [WARN] Not running as Administrator
    echo [WARN] Some features may require elevation
)
echo.

REM Check for PowerShell
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] PowerShell not found!
    echo [ERROR] PowerShell 5.1 or later is required.
    echo.
    echo Please install PowerShell from:
    echo https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows
    echo.
    pause
    exit /b 1
)

REM Get PowerShell version
for /f "tokens=*" %%i in ('powershell -Command "$PSVersionTable.PSVersion.Major"') do set PS_VERSION=%%i
echo [OK] PowerShell %PS_VERSION% detected
echo.

REM Determine script directory
set SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM Check if PowerShell installer exists
set PS_INSTALLER=%SCRIPT_DIR%\LevythonInstaller.ps1

if not exist "%PS_INSTALLER%" (
    echo [ERROR] Installer script not found!
    echo [ERROR] Expected location: %PS_INSTALLER%
    echo.
    echo Please ensure all installer files are present.
    echo.
    pause
    exit /b 1
)

echo [OK] Installer script found
echo.

echo ================================================================================
echo   Installation Options
echo ================================================================================
echo.
echo   1. GUI Installation (Recommended)
echo      - Interactive installation wizard
echo      - Choose installation directory
echo      - Select optional components
echo      - Configure PATH and file associations
echo.
echo   2. Silent Installation
echo      - Automatic installation with defaults
echo      - No user interaction required
echo      - Installs to: C:\Program Files\Levython
echo.
echo   3. Advanced PowerShell Installation
echo      - Full control over installation options
echo      - Custom installation paths
echo      - Component selection
echo.
echo   4. Exit
echo.
echo ================================================================================
echo.

set /p CHOICE="Select an option (1-4): "

if "%CHOICE%"=="1" goto :GUI_INSTALL
if "%CHOICE%"=="2" goto :SILENT_INSTALL
if "%CHOICE%"=="3" goto :ADVANCED_INSTALL
if "%CHOICE%"=="4" goto :EXIT
echo.
echo [ERROR] Invalid choice. Please select 1-4.
echo.
pause
goto :EOF

:GUI_INSTALL
cls
echo.
echo ================================================================================
echo                     GUI INSTALLATION
echo ================================================================================
echo.
echo Starting interactive installation wizard...
echo.
echo This will:
echo   - Guide through the installation process
echo   - Choose installation directory
echo   - Select optional components
echo   - Configure system PATH (optional)
echo   - Set up file associations (optional)
echo   - Install VS Code extension (optional)
echo.
echo Press any key to start the installation...
pause >nul

echo.
echo [INFO] Launching PowerShell installer...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_INSTALLER%"

goto :INSTALL_COMPLETE

:SILENT_INSTALL
cls
echo.
echo ================================================================================
echo                     SILENT INSTALLATION
echo ================================================================================
echo.
echo Installing Levython with default settings...
echo.
echo Installation details:
echo   - Location: C:\Program Files\Levython
echo   - PATH: Will be configured automatically
echo   - File Associations: Will be configured
echo   - VS Code Extension: Will be installed if VS Code is detected
echo.
echo This will complete without further prompts.
echo.
set /p CONFIRM="Continue with silent installation? (Y/N): "

if /i not "%CONFIRM%"=="Y" (
    echo.
    echo Installation cancelled.
    pause
    goto :EOF
)

echo.
echo [INFO] Starting silent installation...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_INSTALLER%" -Silent

goto :INSTALL_COMPLETE

:ADVANCED_INSTALL
cls
echo.
echo ================================================================================
echo                  ADVANCED POWERSHELL INSTALLATION
echo ================================================================================
echo.
echo This will open a PowerShell window with full control over installation options.
echo.
echo Available parameters:
echo   -InstallPath "C:\Path"  : Custom installation directory
echo   -NoPath                 : Don't modify system PATH
echo   -NoFileAssoc            : Don't create file associations
echo   -NoVSCode               : Don't install VS Code extension
echo   -Silent                 : Silent installation
echo   -Portable               : Create portable installation
echo.
echo Example:
echo   .\LevythonInstaller.ps1 -InstallPath "D:\Levython" -NoVSCode
echo.
echo Press any key to open PowerShell installer...
pause >nul

echo.
echo [INFO] Opening PowerShell window...
echo.

start powershell.exe -NoProfile -ExecutionPolicy Bypass -NoExit -Command "cd '%SCRIPT_DIR%'; Write-Host ''; Write-Host 'Levython Advanced Installer' -ForegroundColor Cyan; Write-Host ''; Write-Host 'Run: .\LevythonInstaller.ps1 [options]' -ForegroundColor Yellow; Write-Host 'Help: .\LevythonInstaller.ps1 -Help' -ForegroundColor Yellow; Write-Host ''"

echo.
echo [INFO] PowerShell window opened.
echo [INFO] You can close this window now.
echo.
pause
goto :EOF

:INSTALL_COMPLETE
echo.
echo ================================================================================

if %ERRORLEVEL% EQU 0 (
    echo                   INSTALLATION COMPLETED SUCCESSFULLY
    echo ================================================================================
    echo.
    echo [OK] Levython has been installed successfully!
    echo.
    echo Quick Start:
    echo   1. Open a new command prompt or PowerShell window
    echo   2. Type: levython --version
    echo   3. Try: levython (for interactive REPL)
    echo   4. Run a script: levython yourscript.levy
    echo.
    echo Documentation:
    echo   - Installed examples: Check Start Menu -^> Levython -^> Examples
    echo   - Online docs: https://github.com/levython/levython
    echo   - Quick reference: Type 'levython --help'
    echo.
    echo VS Code Integration:
    echo   - If VS Code extension was installed, restart VS Code
    echo   - Open a .levy file to see syntax highlighting
    echo.
    echo Motto: Be better than yesterday
    echo.
) else (
    echo                      INSTALLATION FAILED
    echo ================================================================================
    echo.
    echo [ERROR] Installation encountered errors. Exit code: %ERRORLEVEL%
    echo.
    echo Common issues:
    echo   - Insufficient permissions (try running as Administrator)
    echo   - Disk space issues
    echo   - Antivirus blocking installation
    echo   - Missing dependencies
    echo.
    echo Troubleshooting:
    echo   1. Right-click this file and select "Run as Administrator"
    echo   2. Temporarily disable antivirus software
    echo   3. Check available disk space (requires ~100 MB)
    echo   4. Review error messages above
    echo.
    echo For help, visit:
    echo   https://github.com/levython/levython/issues
    echo.
)

echo ================================================================================
echo.
pause

:EXIT
endlocal
exit /b %ERRORLEVEL%
