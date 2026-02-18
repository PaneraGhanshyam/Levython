<#
.SYNOPSIS
    Levython Windows Installer Build System

.DESCRIPTION
    Advanced build system for creating Levython installers with enhanced UI/UX.

    Features:
    - Automatic architecture detection (x64, x86, ARM64)
    - Multi-compiler support (GCC, MSVC, Clang)
    - OpenSSL auto-detection
    - Enhanced console output with progress indicators
    - Comprehensive error handling
    - Build verification and validation

.PARAMETER SkipBuild
    Skip the compilation step and use existing binaries

.PARAMETER SkipInnoSetup
    Skip Inno Setup installer creation

.PARAMETER Architecture
    Target architecture: auto, x64, x86, arm64, or all

.PARAMETER Compiler
    Preferred compiler: auto, gcc, msvc, or clang

.PARAMETER Clean
    Clean build directories before building

.EXAMPLE
    .\Build-Installer.ps1
    Build installer for current architecture

.EXAMPLE
    .\Build-Installer.ps1 -Architecture all
    Build installers for all architectures

.EXAMPLE
    .\Build-Installer.ps1 -Clean -Compiler msvc
    Clean build and compile with MSVC

.NOTES
    Author: Levython Authors
    Version: 2.0.0
    Support: levythonhq@gmail.com
    Motto: Be better than yesterday
#>

param(
    [switch]$SkipBuild,
    [switch]$SkipInnoSetup,
    [string]$Architecture = "auto",
    [string]$Compiler = "auto",
    [switch]$Clean
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# ============================================================================
# CONFIGURATION
# ============================================================================
$script:Config = @{
    Version = "1.0.3"
    AppName = "Levython"
    Motto = "Be better than yesterday"
    ProjectRoot = Split-Path -Parent $PSScriptRoot
    BuildDir = $null
    ReleaseDir = $null
    InstallerDir = $PSScriptRoot
    StartTime = Get-Date
}

$script:Config.BuildDir = Join-Path $script:Config.ProjectRoot "build"
$script:Config.ReleaseDir = Join-Path $script:Config.ProjectRoot "releases"

# ============================================================================
# CONSOLE UI FUNCTIONS
# ============================================================================
function Write-Banner {
    param([string]$Title, [string]$Color = "Cyan")

    $width = 80
    $border = "═" * $width

    Write-Host ""
    Write-Host "╔$border╗" -ForegroundColor $Color
    Write-Host "║$((' ' * (($width - $Title.Length) / 2)))$Title$((' ' * (($width - $Title.Length) / 2)))║" -ForegroundColor $Color
    Write-Host "╚$border╝" -ForegroundColor $Color
    Write-Host ""
}

function Write-Section {
    param([string]$Title)

    Write-Host ""
    Write-Host "┌─────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkCyan
    Write-Host "│  $Title" -ForegroundColor Cyan
    Write-Host "└─────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkCyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "  ✓ " -ForegroundColor Green -NoNewline
    Write-Host $Message -ForegroundColor White
}

function Write-Info {
    param([string]$Message)
    Write-Host "  ℹ " -ForegroundColor Cyan -NoNewline
    Write-Host $Message -ForegroundColor Gray
}

function Write-Warning {
    param([string]$Message)
    Write-Host "  ⚠ " -ForegroundColor Yellow -NoNewline
    Write-Host $Message -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "  ✗ " -ForegroundColor Red -NoNewline
    Write-Host $Message -ForegroundColor Red
}

function Write-Step {
    param([string]$Message)
    Write-Host "  ▶ " -ForegroundColor Blue -NoNewline
    Write-Host $Message -ForegroundColor White
}

function Write-Progress {
    param(
        [string]$Activity,
        [int]$PercentComplete,
        [string]$Status
    )

    $barLength = 40
    $completed = [Math]::Floor($barLength * $PercentComplete / 100)
    $remaining = $barLength - $completed

    $bar = "[" + ("█" * $completed) + ("░" * $remaining) + "]"

    Write-Host "`r  $bar $PercentComplete% - $Status" -NoNewline -ForegroundColor Cyan

    if ($PercentComplete -eq 100) {
        Write-Host ""
    }
}

# ============================================================================
# SYSTEM DETECTION
# ============================================================================
function Get-TargetArchitectures {
    if ($Architecture -eq "all") {
        return @("x64", "x86")  # ARM64 requires special setup
    }
    elseif ($Architecture -eq "auto") {
        if ([Environment]::Is64BitOperatingSystem) {
            if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") {
                return @("arm64")
            }
            return @("x64")
        }
        return @("x86")
    }
    else {
        return @($Architecture)
    }
}

function Get-SystemInfo {
    Write-Section "System Information"

    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor

    Write-Info "OS: $($os.Caption) ($($os.Version))"
    Write-Info "Architecture: $($env:PROCESSOR_ARCHITECTURE)"
    Write-Info "CPU: $($cpu.Name)"
    Write-Info "Cores: $($cpu.NumberOfCores) cores, $($cpu.NumberOfLogicalProcessors) threads"
    Write-Info "RAM: $([Math]::Round($os.TotalVisibleMemorySize / 1MB, 2)) GB"
    Write-Info "PowerShell: $($PSVersionTable.PSVersion)"
}

# ============================================================================
# COMPILER DETECTION
# ============================================================================
function Find-Compiler {
    param([string]$PreferredCompiler = "auto")

    Write-Section "Compiler Detection"

    $compilers = @()

    # Check for GCC (MinGW)
    try {
        $gppPath = (Get-Command g++ -ErrorAction SilentlyContinue).Source
        if ($gppPath) {
            $version = (& g++ --version 2>&1 | Select-Object -First 1)
            $compilers += @{
                Type = "gcc"
                Name = "GNU C++ Compiler (MinGW)"
                Path = $gppPath
                Version = $version
                Priority = 1
            }
            Write-Info "Found: GCC - $version"
        }
    }
    catch { }

    # Check for MSVC
    try {
        $vsWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
        if (Test-Path $vsWhere) {
            $vsPath = & $vsWhere -latest -property installationPath 2>$null
            if ($vsPath) {
                $vcvarsall = Join-Path $vsPath "VC\Auxiliary\Build\vcvarsall.bat"
                if (Test-Path $vcvarsall) {
                    $vsVersion = & $vsWhere -latest -property catalog_productDisplayVersion 2>$null
                    $compilers += @{
                        Type = "msvc"
                        Name = "Microsoft Visual C++"
                        Path = $vcvarsall
                        VsPath = $vsPath
                        Version = "MSVC $vsVersion"
                        Priority = 2
                    }
                    Write-Info "Found: MSVC - Visual Studio $vsVersion"
                }
            }
        }
    }
    catch { }

    # Check for Clang
    try {
        $clangPath = (Get-Command clang++ -ErrorAction SilentlyContinue).Source
        if ($clangPath) {
            $version = (& clang++ --version 2>&1 | Select-Object -First 1)
            $compilers += @{
                Type = "clang"
                Name = "Clang/LLVM C++"
                Path = $clangPath
                Version = $version
                Priority = 3
            }
            Write-Info "Found: Clang - $version"
        }
    }
    catch { }

    if ($compilers.Count -eq 0) {
        Write-Error "No C++ compiler found!"
        Write-Warning "Please install one of the following:"
        Write-Host "    • MinGW-w64: https://www.mingw-w64.org/" -ForegroundColor Yellow
        Write-Host "    • Visual Studio: https://visualstudio.microsoft.com/" -ForegroundColor Yellow
        Write-Host "    • LLVM/Clang: https://llvm.org/" -ForegroundColor Yellow
        throw "No compiler available"
    }

    # Select compiler
    if ($PreferredCompiler -ne "auto") {
        $selected = $compilers | Where-Object { $_.Type -eq $PreferredCompiler.ToLower() } | Select-Object -First 1
        if ($selected) {
            Write-Success "Selected: $($selected.Name)"
            return $selected
        }
        Write-Warning "Preferred compiler '$PreferredCompiler' not found, using default"
    }

    $selected = $compilers | Sort-Object Priority | Select-Object -First 1
    Write-Success "Selected: $($selected.Name)"

    return $selected
}

# ============================================================================
# OPENSSL DETECTION
# ============================================================================
function Find-OpenSSL {
    Write-Section "OpenSSL Detection"

    $candidates = @()
    
    # Environment variable
    if ($env:OPENSSL_DIR) {
        $candidates += $env:OPENSSL_DIR
    }
    
    # Scoop installations (user)
    if ($env:USERPROFILE) {
        $candidates += "$env:USERPROFILE\scoop\apps\openssl\current"
        $candidates += "$env:USERPROFILE\scoop\apps\openssl-3\current"
        $candidates += "$env:USERPROFILE\scoop\apps\mingw\current\opt"
        $candidates += "$env:USERPROFILE\scoop\apps\mingw\current"
    }
    
    # Scoop installations (global)
    $candidates += "C:\ProgramData\scoop\apps\openssl\current"
    $candidates += "C:\ProgramData\scoop\apps\openssl-3\current"
    
    # Standard Windows installations (x64)
    $candidates += "C:\OpenSSL-Win64"
    $candidates += "${env:ProgramFiles}\OpenSSL-Win64"
    $candidates += "C:\Program Files\OpenSSL-Win64"
    $candidates += "${env:ProgramFiles}\OpenSSL"
    $candidates += "C:\Program Files\OpenSSL"
    
    # Standard Windows installations (x86)
    $candidates += "C:\OpenSSL-Win32"
    $candidates += "${env:ProgramFiles(x86)}\OpenSSL-Win32"
    $candidates += "C:\Program Files (x86)\OpenSSL-Win32"
    $candidates += "${env:ProgramFiles(x86)}\OpenSSL"
    $candidates += "C:\Program Files (x86)\OpenSSL"
    
    # vcpkg installations
    $candidates += "C:\vcpkg\installed\x64-windows"
    $candidates += "C:\vcpkg\installed\x86-windows"
    if ($env:VCPKG_ROOT) {
        $candidates += "$env:VCPKG_ROOT\installed\x64-windows"
        $candidates += "$env:VCPKG_ROOT\installed\x86-windows"
    }
    
    # MSYS2/MinGW installations
    $candidates += "C:\msys64\mingw64"
    $candidates += "C:\msys64\ucrt64"
    $candidates += "C:\msys64\mingw32"
    $candidates += "C:\msys64\clang64"
    $candidates += "C:\msys32\mingw32"
    
    # Check if g++ is available and get its root
    try {
        $gppPath = (Get-Command g++ -ErrorAction SilentlyContinue)
        if ($gppPath) {
            $mingwRoot = Split-Path (Split-Path $gppPath.Source)
            $candidates += $mingwRoot
            $candidates += "$mingwRoot\opt"
            $candidates += "$mingwRoot\.."
        }
    }
    catch { }
    
    # Remove duplicates and empty entries
    $candidates = $candidates | Where-Object { $_ } | Select-Object -Unique

    foreach ($base in $candidates) {
        if (-not (Test-Path $base)) { continue }

        $inc = Join-Path $base "include"
        $lib = Join-Path $base "lib"

        # Check for OpenSSL headers
        $opensslHeader = Join-Path $inc "openssl\ssl.h"

        if ((Test-Path $inc) -and (Test-Path $lib) -and (Test-Path $opensslHeader)) {
            # Smart lib path resolution: check VC subdirectory layout first (manual installs from slproweb)
            $resolvedLib = $null
            
            # MSVC-style: lib\VC\x64\MT, lib\VC\x64\MD, etc.
            $vcSubPaths = @("VC\x64\MT", "VC\x64\MD", "VC\x64\MTd", "VC\x64\MDd", "VC\x86\MT", "VC\x86\MD", "VC\Win32\MT", "VC\Win32\MD")
            foreach ($sub in $vcSubPaths) {
                $vcLib = Join-Path $lib $sub
                if (Test-Path (Join-Path $vcLib "libssl.lib")) {
                    $resolvedLib = $vcLib
                    Write-Info "Using VC lib layout: $sub"
                    break
                }
            }
            
            # Direct lib\ with .lib files (vcpkg, chocolatey)
            if (-not $resolvedLib) {
                $directLibs = @("libssl.lib", "ssl.lib", "ssleay32.lib", "libssl.a", "libcrypto.a")
                foreach ($f in $directLibs) {
                    if (Test-Path (Join-Path $lib $f)) {
                        $resolvedLib = $lib
                        break
                    }
                }
            }
            
            # MinGW .dll.a
            if (-not $resolvedLib) {
                if ((Get-ChildItem $lib -Filter "*.dll.a" -ErrorAction SilentlyContinue).Count -gt 0) {
                    $resolvedLib = $lib
                }
            }
            
            if (-not $resolvedLib) {
                Write-Warning "Headers found at $base but no libs in $lib (checked VC subdirs too)"
                continue
            }
            
            # Try to find version
            $version = "Unknown"
            try {
                $versionFile = Join-Path $inc "openssl\opensslv.h"
                if (Test-Path $versionFile) {
                    $content = Get-Content $versionFile -Raw
                    if ($content -match 'OPENSSL_VERSION_TEXT\s+"OpenSSL\s+([\d.]+\w*)"') {
                        $version = $matches[1]
                    }
                    elseif ($content -match 'OPENSSL_VERSION_STR\s+"([\d.]+\w*)"') {
                        $version = $matches[1]
                    }
                }
            }
            catch { }

            Write-Success "Found: OpenSSL $version"
            Write-Info "Location: $base"
            Write-Info "Include: $inc"
            Write-Info "Library: $resolvedLib"

            return @{
                Include = $inc
                Lib = $resolvedLib
                Version = $version
                BasePath = $base
            }
        }
    }

    Write-Error "OpenSSL not found!"
    Write-Warning "Searched in all common locations including:"
    Write-Host "  • Scoop: $env:USERPROFILE\scoop\apps\openssl\current" -ForegroundColor Gray
    Write-Host "  • Standard: C:\OpenSSL-Win64, C:\Program Files\OpenSSL-Win64" -ForegroundColor Gray
    Write-Host "  • vcpkg: C:\vcpkg\installed\x64-windows" -ForegroundColor Gray
    Write-Host "  • MSYS2: C:\msys64\mingw64" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Installation options:" -ForegroundColor Yellow
    Write-Host "  1. Download from: https://slproweb.com/products/Win32OpenSSL.html" -ForegroundColor Gray
    Write-Host "  2. Install via vcpkg: vcpkg install openssl" -ForegroundColor Gray
    Write-Host "  3. Install via Scoop: scoop install openssl" -ForegroundColor Gray
    Write-Host "  4. Install via Chocolatey: choco install openssl" -ForegroundColor Gray
    Write-Host "  5. Set OPENSSL_DIR environment variable to your installation path" -ForegroundColor Gray

    throw "OpenSSL not found"
}

# ============================================================================
# BUILD FUNCTIONS
# ============================================================================
function Build-Executable {
    param(
        [string]$Arch,
        [hashtable]$Compiler,
        [hashtable]$OpenSSL
    )

    Write-Section "Building Levython ($Arch)"

    $outputPath = Join-Path $script:Config.ReleaseDir "levython-windows-$Arch.exe"
    $srcFile = Join-Path $script:Config.ProjectRoot "src\levython.cpp"
    $httpFile = Join-Path $script:Config.ProjectRoot "src\http_client.cpp"

    # Gather source files
    $srcFiles = @($srcFile)
    if (Test-Path $httpFile) {
        $srcFiles += $httpFile
        Write-Info "Including HTTP client module"
    }

    if (-not (Test-Path $srcFile)) {
        throw "Source file not found: $srcFile"
    }

    Write-Step "Compiling with $($Compiler.Name)..."
    Write-Info "Target: $Arch"
    Write-Info "Output: $outputPath"

    $buildSuccess = $false
    $buildOutput = ""

    try {
        switch ($Compiler.Type) {
            "gcc" {
                $archFlag = switch ($Arch) {
                    "x64" { "-m64" }
                    "x86" { "-m32" }
                    "arm64" { "" }
                }

                $compileArgs = @(
                    "-std=c++17",
                    "-O3",
                    "-DNDEBUG",
                    "-march=native",
                    "-mtune=native",
                    "-ffast-math",
                    "-flto",
                    "-static",
                    "-static-libgcc",
                    "-static-libstdc++",
                    "-fexceptions",
                    "-s",
                    "-I", "`"$($OpenSSL.Include)`"",
                    "-L", "`"$($OpenSSL.Lib)`"",
                    "-lssl",
                    "-lcrypto",
                    "-lws2_32",
                    "-lcrypt32",
                    "-lwinmm",
                    "-o", "`"$outputPath`""
                ) + $srcFiles

                if ($archFlag) {
                    $compileArgs = @($archFlag) + $compileArgs
                }

                Write-Progress -Activity "Building" -PercentComplete 10 -Status "Compiling source files"
                $buildOutput = & g++ $compileArgs 2>&1 | Out-String
                Write-Progress -Activity "Building" -PercentComplete 100 -Status "Complete"
            }

            "msvc" {
                $msvcArch = switch ($Arch) {
                    "x64" { "x64" }
                    "x86" { "x86" }
                    "arm64" { "arm64" }
                }

                $srcList = ($srcFiles | ForEach-Object { "`"$_`"" }) -join " "

                $buildCmd = @"
@echo off
call "$($Compiler.Path)" $msvcArch >nul 2>&1
if errorlevel 1 exit /b 1

cl.exe /std:c++17 /O2 /GL /EHsc /DNDEBUG /MT ^
    /I"$($OpenSSL.Include)" ^
    /Fe:"$outputPath" ^
    $srcList ^
    /link /LTCG /OPT:REF /OPT:ICF ^
    /LIBPATH:"$($OpenSSL.Lib)" ^
    libssl.lib libcrypto.lib ws2_32.lib crypt32.lib winmm.lib
"@

                $buildScript = Join-Path $script:Config.BuildDir "build_msvc_$Arch.bat"
                $buildCmd | Set-Content -Path $buildScript -Encoding ASCII

                Write-Progress -Activity "Building" -PercentComplete 10 -Status "Compiling source files"
                $buildOutput = cmd.exe /c $buildScript 2>&1 | Out-String
                Write-Progress -Activity "Building" -PercentComplete 100 -Status "Complete"
            }

            "clang" {
                $compileArgs = @(
                    "-std=c++17",
                    "-O3",
                    "-DNDEBUG",
                    "-march=native",
                    "-flto",
                    "-static",
                    "-fexceptions",
                    "-I", "`"$($OpenSSL.Include)`"",
                    "-L", "`"$($OpenSSL.Lib)`"",
                    "-lssl",
                    "-lcrypto",
                    "-lws2_32",
                    "-lcrypt32",
                    "-lwinmm",
                    "-o", "`"$outputPath`""
                ) + $srcFiles

                Write-Progress -Activity "Building" -PercentComplete 10 -Status "Compiling source files"
                $buildOutput = & clang++ $compileArgs 2>&1 | Out-String
                Write-Progress -Activity "Building" -PercentComplete 100 -Status "Complete"
            }
        }

        if (Test-Path $outputPath) {
            $buildSuccess = $true
        }
    }
    catch {
        $buildOutput = $_.Exception.Message
    }

    if ($buildSuccess) {
        $sizeMB = [Math]::Round((Get-Item $outputPath).Length / 1MB, 2)
        Write-Success "Build completed: $outputPath ($sizeMB MB)"

        # Verify executable
        Write-Step "Verifying executable..."
        try {
            $verOutput = & $outputPath --version 2>&1 | Out-String
            if ($verOutput -match "Levython|version") {
                Write-Success "Executable verified successfully"
                Write-Info $verOutput.Trim()
            }
            else {
                Write-Warning "Verification produced unexpected output"
            }
        }
        catch {
            Write-Warning "Could not verify executable: $_"
        }

        return $outputPath
    }
    else {
        Write-Error "Build failed!"
        if ($buildOutput) {
            Write-Host ""
            Write-Host "Build Output:" -ForegroundColor Red
            Write-Host $buildOutput -ForegroundColor DarkRed
        }
        throw "Compilation failed for $Arch"
    }
}

# ============================================================================
# INNO SETUP
# ============================================================================
function Find-InnoSetup {
    Write-Section "Inno Setup Detection"

    $isccPaths = @(
        "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
        "${env:ProgramFiles}\Inno Setup 6\ISCC.exe",
        "${env:ProgramFiles(x86)}\Inno Setup 5\ISCC.exe",
        "${env:ProgramFiles}\Inno Setup 5\ISCC.exe"
    )

    foreach ($path in $isccPaths) {
        if (Test-Path $path) {
            try {
                $version = (& $path 2>&1 | Select-String "Inno Setup" | Select-Object -First 1 | Out-String).Trim()
            }
            catch {
                $version = "Version unknown"
            }
            Write-Success "Found: Inno Setup"
            if ($version) { Write-Info $version }
            Write-Info "Path: $path"
            return $path
        }
    }

    Write-Warning "Inno Setup not found!"
    Write-Info "Download from: https://jrsoftware.org/isdl.php"

    return $null
}

function Build-InnoSetupInstaller {
    $iscc = Find-InnoSetup

    if (-not $iscc) {
        Write-Warning "Skipping Inno Setup installer creation"
        return $null
    }

    Write-Section "Creating Installer"

    $issFile = Join-Path $script:Config.InstallerDir "levython-setup.iss"

    if (-not (Test-Path $issFile)) {
        Write-Error "Inno Setup script not found: $issFile"
        return $null
    }

    Write-Step "Building installer with Inno Setup..."
    Write-Info "Script: $issFile"

    try {
        Write-Progress -Activity "Installer" -PercentComplete 20 -Status "Compiling installer"
        $output = & $iscc $issFile 2>&1 | Out-String
        Write-Progress -Activity "Installer" -PercentComplete 100 -Status "Complete"
        
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Inno Setup compilation had warnings or errors"
            Write-Host $output -ForegroundColor Yellow
        }

        $installerPath = Join-Path $script:Config.ReleaseDir "levython-$($script:Config.Version)-windows-setup.exe"

        if (Test-Path $installerPath) {
            $sizeMB = [Math]::Round((Get-Item $installerPath).Length / 1MB, 2)
            Write-Success "Installer created: $installerPath ($sizeMB MB)"
            return $installerPath
        }
        else {
            Write-Warning "Installer file not found at expected location"
            return $null
        }
    }
    catch {
        Write-Error "Inno Setup failed: $_"
        return $null
    }
}

# ============================================================================
# PACKAGE CREATION
# ============================================================================
function Create-PortablePackage {
    param([string[]]$Executables)

    Write-Section "Creating Portable Packages"

    $packages = @()

    foreach ($exe in $Executables) {
        if (-not (Test-Path $exe)) { continue }

        $arch = if ($exe -match "x64") { "x64" }
                elseif ($exe -match "x86") { "x86" }
                elseif ($exe -match "arm64") { "arm64" }
                else { "unknown" }

        Write-Step "Packaging $arch build..."

        $packageDir = Join-Path $script:Config.BuildDir "package-$arch"
        Remove-Item -Path $packageDir -Recurse -Force -ErrorAction SilentlyContinue
        New-Item -ItemType Directory -Path $packageDir -Force | Out-Null

        # Copy executable
        Copy-Item -Path $exe -Destination (Join-Path $packageDir "levython.exe")

        # Copy logo
        $logo = Join-Path $script:Config.ProjectRoot "icon.png"
        if (Test-Path $logo) {
            Copy-Item -Path $logo -Destination $packageDir
        }

        # Copy documentation
        $docs = @("README.md", "LICENSE", "CHANGELOG.md", "QUICKREF.md")
        $docsDir = Join-Path $packageDir "docs"
        New-Item -ItemType Directory -Path $docsDir -Force | Out-Null

        foreach ($doc in $docs) {
            $docPath = Join-Path $script:Config.ProjectRoot $doc
            if (Test-Path $docPath) {
                Copy-Item -Path $docPath -Destination $docsDir
            }
        }

        # Copy examples
        $examplesDir = Join-Path $script:Config.ProjectRoot "examples"
        if (Test-Path $examplesDir) {
            Copy-Item -Path $examplesDir -Destination (Join-Path $packageDir "examples") -Recurse
        }

        # Copy VS Code extension
        $vscodeDir = Join-Path $script:Config.ProjectRoot "vscode-levython"
        if (Test-Path $vscodeDir) {
            Copy-Item -Path $vscodeDir -Destination (Join-Path $packageDir "vscode-levython") -Recurse
        }

        # Create README for portable version
        $portableReadme = @"
# Levython Portable - $arch

This is a portable version of Levython $($script:Config.Version).

## Quick Start

1. Add this directory to your PATH, or
2. Run levython.exe directly from this folder

## Usage

    levython.exe --version
    levython.exe --help
    levython.exe script.levy
    levython.exe  (for REPL)

## Documentation

See the 'docs' folder for full documentation.

## Examples

Check out the 'examples' folder for sample scripts.

## Motto

$($script:Config.Motto)

---
For more information, visit: https://github.com/levython/levython
"@

        $portableReadme | Set-Content -Path (Join-Path $packageDir "README_PORTABLE.txt") -Encoding UTF8

        # Create ZIP package
        $zipPath = Join-Path $script:Config.ReleaseDir "levython-$($script:Config.Version)-windows-$arch-portable.zip"
        Remove-Item -Path $zipPath -Force -ErrorAction SilentlyContinue

        Write-Progress -Activity "Packaging" -PercentComplete 50 -Status "Creating ZIP archive"
        Compress-Archive -Path "$packageDir\*" -DestinationPath $zipPath -CompressionLevel Optimal -Force
        Write-Progress -Activity "Packaging" -PercentComplete 100 -Status "Complete"

        if (Test-Path $zipPath) {
            $sizeMB = [Math]::Round((Get-Item $zipPath).Length / 1MB, 2)
            Write-Success "Package created: levython-$($script:Config.Version)-windows-$arch-portable.zip ($sizeMB MB)"
            $packages += $zipPath
        }
    }

    return $packages
}

# ============================================================================
# CLEANUP
# ============================================================================
function Clean-BuildDirectories {
    Write-Section "Cleaning Build Directories"

    if (Test-Path $script:Config.BuildDir) {
        Write-Step "Removing build directory..."
        Remove-Item -Path $script:Config.BuildDir -Recurse -Force
        Write-Success "Build directory cleaned"
    }

    New-Item -ItemType Directory -Path $script:Config.BuildDir -Force | Out-Null
}

# ============================================================================
# SUMMARY
# ============================================================================
function Show-BuildSummary {
    param(
        [string[]]$Executables,
        [string[]]$Packages,
        [string]$Installer
    )

    $elapsed = (Get-Date) - $script:Config.StartTime

    Write-Banner "BUILD COMPLETED SUCCESSFULLY" -Color Green

    Write-Host "╔═══════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                           BUILD SUMMARY                                   ║" -ForegroundColor Green
    Write-Host "╠═══════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Green
    Write-Host "║  Version:        $($script:Config.Version)                                                      ║" -ForegroundColor White
    Write-Host "║  Time Elapsed:   $($elapsed.ToString('hh\:mm\:ss'))                                                   ║" -ForegroundColor White
    Write-Host "╠═══════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Green

    if ($Executables.Count -gt 0) {
        Write-Host "║  Executables:                                                             ║" -ForegroundColor Cyan
        foreach ($exe in $Executables) {
            $name = Split-Path $exe -Leaf
            $size = [Math]::Round((Get-Item $exe).Length / 1MB, 2)
            Write-Host "║    • $name ($size MB)" -ForegroundColor White
        }
    }

    if ($Packages.Count -gt 0) {
        Write-Host "║  Packages:                                                                ║" -ForegroundColor Cyan
        foreach ($pkg in $Packages) {
            $name = Split-Path $pkg -Leaf
            $size = [Math]::Round((Get-Item $pkg).Length / 1MB, 2)
            Write-Host "║    • $name ($size MB)" -ForegroundColor White
        }
    }

    if ($Installer) {
        $name = Split-Path $Installer -Leaf
        $size = [Math]::Round((Get-Item $Installer).Length / 1MB, 2)
        Write-Host "║  Installer:                                                               ║" -ForegroundColor Cyan
        Write-Host "║    • $name ($size MB)" -ForegroundColor White
    }

    Write-Host "╠═══════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Green
    Write-Host "║  Output Directory: $($script:Config.ReleaseDir)" -ForegroundColor Yellow
    Write-Host "╚═══════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Motto: $($script:Config.Motto)" -ForegroundColor Magenta
    Write-Host ""
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================
try {
    # Display banner
    Write-Banner "LEVYTHON BUILD SYSTEM"

    Write-Host "  Version:  $($script:Config.Version)" -ForegroundColor Cyan
    Write-Host "  Support:  levythonhq@gmail.com" -ForegroundColor Cyan
    Write-Host "  Motto:    $($script:Config.Motto)" -ForegroundColor Magenta
    Write-Host ""

    # Create directories
    New-Item -ItemType Directory -Path $script:Config.BuildDir -Force | Out-Null
    New-Item -ItemType Directory -Path $script:Config.ReleaseDir -Force | Out-Null

    # Clean if requested
    if ($Clean) {
        Clean-BuildDirectories
    }

    # Get system info
    Get-SystemInfo

    # Build executables
    $builtExecutables = @()

    if (-not $SkipBuild) {
        $compiler = Find-Compiler -PreferredCompiler $Compiler
        $openssl = Find-OpenSSL
        $architectures = Get-TargetArchitectures

        Write-Section "Build Configuration"
        Write-Info "Target Architectures: $($architectures -join ', ')"
        Write-Info "Compiler: $($compiler.Name)"
        Write-Info "OpenSSL: $($openssl.Version)"

        foreach ($arch in $architectures) {
            try {
                $exe = Build-Executable -Arch $arch -Compiler $compiler -OpenSSL $openssl
                $builtExecutables += $exe
            }
            catch {
                Write-Error "Failed to build $arch`: $_"
            }
        }
    }
    else {
        Write-Section "Skipping Build"
        Write-Info "Using existing executables from releases directory"

        # Find existing executables
        $exePattern = Join-Path $script:Config.ReleaseDir "levython-windows-*.exe"
        $existingExes = Get-ChildItem -Path $exePattern -ErrorAction SilentlyContinue

        foreach ($exe in $existingExes) {
            Write-Info "Found: $($exe.Name)"
            $builtExecutables += $exe.FullName
        }

        if ($builtExecutables.Count -eq 0) {
            Write-Warning "No existing executables found. Consider running without -SkipBuild"
        }
    }

    # Create portable packages
    $packages = @()
    if ($builtExecutables.Count -gt 0) {
        $packages = Create-PortablePackage -Executables $builtExecutables
    }

    # Create Inno Setup installer
    $installer = $null
    if (-not $SkipInnoSetup) {
        $installer = Build-InnoSetupInstaller
    }
    else {
        Write-Section "Skipping Inno Setup"
        Write-Info "Use without -SkipInnoSetup to create professional installer"
    }

    # Show summary
    Show-BuildSummary -Executables $builtExecutables -Packages $packages -Installer $installer

    # Open releases folder
    Write-Host "Opening releases folder..." -ForegroundColor Cyan
    Start-Process explorer.exe -ArgumentList $script:Config.ReleaseDir

    exit 0
}
catch {
    Write-Host ""
    Write-Banner "BUILD FAILED" -Color Red
    Write-Host ""
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Stack Trace:" -ForegroundColor DarkRed
    Write-Host $_.ScriptStackTrace -ForegroundColor DarkRed
    Write-Host ""

    exit 1
}
