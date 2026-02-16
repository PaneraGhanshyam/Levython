# 🎯 Levython Windows Installer - Complete Guide

**Installation System for Levython Programming Language**

> *"Be better than yesterday"* - Levython Motto

---

## 📑 Table of Contents

1. [Introduction](#introduction)
2. [What's New - UI/UX Upgrades](#whats-new---uiux-upgrades)
3. [System Requirements](#system-requirements)
4. [Installation Methods](#installation-methods)
5. [Quick Start for End Users](#quick-start-for-end-users)
6. [Quick Start for Developers](#quick-start-for-developers)
7. [Build System Overview](#build-system-overview)
8. [Detailed Build Instructions](#detailed-build-instructions)
9. [Inno Setup Installer Features](#inno-setup-installer-features)
10. [Customization Guide](#customization-guide)
11. [Troubleshooting](#troubleshooting)
12. [FAQ](#faq)
13. [Advanced Topics](#advanced-topics)
14. [Contributing](#contributing)

---

## 🎨 Introduction

This installer system provides an **enhanced UI/UX** installation experience for Levython on Windows. It combines:

- **Modern interface** with custom branding
- **Intelligent auto-detection** of system capabilities
- **Multiple installation formats** for different use cases
- **Comprehensive error handling** and user guidance
- **Quality assurance** with extensive testing

---

## ✨ What's New - UI/UX Upgrades

### Key Features

✅ **Custom Logo Integration**
- Levython logo (`icon.png`) displayed throughout installation
- Branded wizard pages with consistent theme
- Professional icon in Windows programs list

✅ **Modern Windows 11/10 UI**
- Resizable installer window (125% size)
- Smooth progress indicators with Unicode icons
- Enhanced color scheme (Cyan/Blue/Green)
- Custom wizard pages with rich information

✅ **Enhanced User Experience**
- Multi-language support (10+ languages)
- Detailed progress feedback during installation
- Custom welcome and finish pages
- Architecture auto-detection display
- Comprehensive quick start guide in finish page

✅ **Enhanced Console Output**
- Unicode box-drawing characters
- Color-coded messages (Success/Info/Warning/Error)
- Progress bars with percentage display
- Enhanced banners and sections

✅ **Smart Installation**
- Automatic compiler detection (GCC/MSVC/Clang)
- OpenSSL auto-discovery from multiple locations
- Build verification with version check
- File size and installation time display

---

## 💻 System Requirements

### Minimum Requirements

| Component | Requirement |
|-----------|-------------|
| **OS** | Windows 7 SP1 or later |
| **RAM** | 512 MB (2 GB recommended) |
| **Disk Space** | 100 MB free space |
| **PowerShell** | 5.1 or later (pre-installed on Win10/11) |

### Recommended for Building

| Component | Recommendation |
|-----------|----------------|
| **OS** | Windows 10 21H2 or Windows 11 |
| **RAM** | 4 GB or more |
| **CPU** | Multi-core processor (for faster compilation) |
| **Compiler** | MinGW-w64 GCC 11+ or MSVC 2019+ |
| **OpenSSL** | 1.1.1 or 3.x |

### Architecture Support

- ✅ **x64** (64-bit Intel/AMD) - Primary target
- ✅ **x86** (32-bit Intel/AMD) - Legacy support
- ✅ **ARM64** (Windows on ARM) - Experimental

---

## 🚀 Installation Methods

### Method 1: GUI Installer (Recommended)

**Best for:** End users, Production deployments

```batch
levython-1.0.3-windows-setup.exe
```

**Features:**
- One-click installation
- Guided setup wizard
- Automatic PATH configuration
- File association setup
- VS Code extension installation
- Clean uninstaller

**Installation Time:** ~2 minutes

---

### Method 2: Portable Package

**Best for:** Developers, USB installations, No-admin scenarios

```batch
levython-1.0.3-windows-x64-portable.zip
```

**Features:**
- No installation required
- Extract and run
- Includes all examples and docs
- Perfect for testing

**Setup Time:** ~30 seconds

---

### Method 3: PowerShell Installer

**Best for:** Automated deployments, CI/CD, Network installs

```powershell
.\LevythonInstaller.ps1
```

**Features:**
- Scriptable installation
- Custom parameters
- Network deployment support
- Silent installation mode

**Installation Time:** ~1-3 minutes

---

## 🎯 Quick Start for End Users

### Step 1: Download

Visit the releases page and download:
```
levython-1.0.3-windows-setup.exe
```

### Step 2: Run Installer

Double-click the downloaded file. Windows SmartScreen may appear:
1. Click "More info"
2. Click "Run anyway"

### Step 3: Follow Wizard

1. **Welcome Page** - Click "Next"
2. **Information Page** - Read about Levython features
3. **License Agreement** - Accept and click "Next"
4. **Installation Directory** - Choose location (default: `C:\Program Files\Levython`)
5. **Components** - Select what to install (all recommended)
6. **Tasks** - Configure options:
   - ☑ Add to system PATH (recommended)
   - ☑ File associations (.levy, .ly)
   - ☑ VS Code extension (if VS Code installed)
   - ☐ Desktop icon (optional)
7. **Ready to Install** - Review and click "Install"
8. **Installing** - Wait for completion (~2 minutes)
9. **Finish** - Click "Finish" to complete

### Step 4: Verify Installation

Open Command Prompt or PowerShell:

```bash
levython --version
```

Expected output:
```
Levython 1.0.3 - High Performance Programming Language
```

### Step 5: Try It Out!

```bash
# Interactive REPL
levython

# Run example
levython "C:\Program Files\Levython\examples\01_hello_world.levy"
```

---

## 🔧 Quick Start for Developers

### Prerequisites Check

```powershell
# Check PowerShell version
$PSVersionTable.PSVersion

# Check for compiler
where g++      # MinGW
where cl       # MSVC
where clang++  # Clang

# Check for OpenSSL
dir "C:\OpenSSL-Win64"
```

### Build Everything

```powershell
cd installer
.\Build-Installer.ps1
```

This single command will:
1. ✅ Detect your system architecture
2. ✅ Find the best C++ compiler
3. ✅ Locate OpenSSL libraries
4. ✅ Compile Levython with optimizations
5. ✅ Verify the executable
6. ✅ Create portable ZIP packages
7. ✅ Build professional GUI installer
8. ✅ Display beautiful summary

**Expected Time:** 3-10 minutes (depending on CPU)

### Output Files

After successful build:

```
releases/
├── levython-windows-x64.exe                      # Executable
├── levython-1.0.3-windows-x64-portable.zip       # Portable package
└── levython-1.0.3-windows-setup.exe              # GUI installer
```

---

## 🏗️ Build System Overview

### Architecture

```
Build-Installer.ps1          Main orchestrator
    ├── System Detection     (Architecture, OS, Resources)
    ├── Compiler Detection   (GCC, MSVC, Clang)
    ├── OpenSSL Detection    (Multiple search paths)
    ├── Compilation          (Optimized builds)
    ├── Verification         (--version check)
    ├── Packaging            (ZIP creation)
    └── Inno Setup           (GUI installer)
```

### Console UI Features

**Professional Output:**
- ╔═══╗ Box-drawing characters
- ✓ ✗ ⚠ ℹ Status icons
- [█████░░░] Progress bars
- Color-coded messages
- Section headers
- Build summary tables

**Example Output:**
```
╔══════════════════════════════════════════════════════════════╗
║        LEVYTHON PROFESSIONAL BUILD SYSTEM                    ║
╚══════════════════════════════════════════════════════════════╝

  ✓ Found: GCC 11.2.0
  ✓ Found: OpenSSL 3.0.8
  ▶ Compiling Levython...
  [████████████████████████] 100% - Complete
  ✓ Build completed: levython-windows-x64.exe (2.1 MB)
```

---

## 📖 Detailed Build Instructions

### Building for Current Architecture

```powershell
# Auto-detect and build for your system
.\Build-Installer.ps1
```

### Building for All Architectures

```powershell
# Build x64 and x86 versions
.\Build-Installer.ps1 -Architecture all
```

### Clean Build

```powershell
# Remove old build files and rebuild
.\Build-Installer.ps1 -Clean
```

### Specifying Compiler

```powershell
# Use specific compiler
.\Build-Installer.ps1 -Compiler gcc    # MinGW GCC
.\Build-Installer.ps1 -Compiler msvc   # Visual Studio
.\Build-Installer.ps1 -Compiler clang  # LLVM Clang
```

### Skipping Compilation

```powershell
# Only create installers from existing binaries
.\Build-Installer.ps1 -SkipBuild
```

### Skipping Inno Setup

```powershell
# Build executable and portable package only
.\Build-Installer.ps1 -SkipInnoSetup
```

### Combined Options

```powershell
# Clean build for all architectures with MSVC
.\Build-Installer.ps1 -Architecture all -Compiler msvc -Clean

# Quick repackaging
.\Build-Installer.ps1 -SkipBuild -SkipInnoSetup
```

---

## 🎨 Inno Setup Installer Features

### Modern UI Elements

**Custom Wizard Pages:**
1. **Welcome Page**
   - Levython logo display
   - Version information
   - Architecture detection
   - Motto display

2. **Information Page**
   - Feature highlights
   - JIT compilation benefits
   - Standard library overview
   - Target architecture

3. **License Agreement**
   - Full MIT license text
   - Accept/Decline options

4. **Select Destination**
   - Custom path selection
   - Disk space validation
   - Default: `C:\Program Files\Levython`

5. **Select Components**
   - Core Runtime (required)
   - Documentation & Examples
   - VS Code Extension

6. **Additional Tasks**
   - Add to system PATH
   - File associations
   - VS Code extension
   - Desktop icon

7. **Ready to Install**
   - Review all settings
   - Final confirmation

8. **Installing**
   - Real-time progress
   - File copy status
   - Configuration steps

9. **Finish Page**
   - Success message
   - Quick start guide
   - Launch options
   - Documentation links
   - Support contact

### Installation Actions

**Automatic Configuration:**
- ✅ Copies executable to `bin/` subdirectory
- ✅ Creates Start Menu shortcuts
- ✅ Adds to system PATH (if selected)
- ✅ Registers file associations (if selected)
- ✅ Installs VS Code extension (if selected)
- ✅ Creates registry entries
- ✅ Sets up uninstaller
- ✅ Copies documentation and examples

### Silent Installation

```batch
REM Completely silent
levython-1.0.3-windows-setup.exe /VERYSILENT /NORESTART

REM Silent with progress
levython-1.0.3-windows-setup.exe /SILENT /NORESTART

REM Custom installation directory
levython-1.0.3-windows-setup.exe /VERYSILENT /DIR="D:\Levython"

REM No PATH modification
levython-1.0.3-windows-setup.exe /VERYSILENT /TASKS="!addtopath"
```

### Uninstallation

**GUI Method:**
1. Settings → Apps → Levython → Uninstall

**Silent Method:**
```batch
"C:\Program Files\Levython\unins000.exe" /VERYSILENT
```

**What Gets Removed:**
- All installed files
- Registry entries
- PATH modifications
- File associations
- Start Menu shortcuts
- VS Code extension

---

## 🎨 Customization Guide

### Updating the Logo

Replace `icon.png` in the project root with your custom logo:

**Requirements:**
- Format: PNG (recommended) or BMP
- Size: 256x256 pixels or larger
- Transparent background (optional)

The logo will automatically appear:
- In the installer wizard
- As program icon
- In Windows Programs list
- On desktop shortcuts

### Customizing Inno Setup Script

Edit `levython-setup.iss`:

**Change Installation Directory:**
```ini
DefaultDirName={autopf}\YourCompany\Levython
```

**Modify Version:**
```ini
#define MyAppVersion "1.0.4"
```

**Add Custom Files:**
```ini
[Files]
Source: "..\your-file.txt"; DestDir: "{app}"; Flags: ignoreversion
```

**Change Company Name:**
```ini
#define MyAppPublisher "Your Company Name"
```

### Customizing PowerShell Installer

Edit `Build-Installer.ps1`:

**Change Version:**
```powershell
$script:Config = @{
    Version = "1.0.4"
    AppName = "Levython"
}
```

**Modify Compiler Flags:**
```powershell
$compileArgs = @(
    "-std=c++17",
    "-O3",
    "-march=native",
    # Add your custom flags here
)
```

**Add Custom Build Steps:**
```powershell
function Custom-BuildStep {
    Write-Section "Custom Build Step"
    # Your custom code here
}
```

---

## 🔍 Troubleshooting

### Build Issues

#### Problem: "No C++ compiler found"

**Solution:**

1. Install MinGW-w64:
   ```powershell
   # Using Chocolatey
   choco install mingw
   
   # Or download from
   # https://www.mingw-w64.org/downloads/
   ```

2. Install Visual Studio:
   - Download Visual Studio 2019 or 2022
   - Install "Desktop development with C++"

3. Install LLVM:
   ```powershell
   choco install llvm
   ```

#### Problem: "OpenSSL not found"

**Solution 1 - Download Installer:**
```
https://slproweb.com/products/Win32OpenSSL.html
Install: Win64 OpenSSL v3.x.x
```

**Solution 2 - vcpkg:**
```powershell
git clone https://github.com/microsoft/vcpkg
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg install openssl:x64-windows
set OPENSSL_DIR=C:\path\to\vcpkg\installed\x64-windows
```

**Solution 3 - Chocolatey:**
```powershell
choco install openssl
```

#### Problem: "Build failed with linker errors"

**Common Causes:**
1. Missing OpenSSL libraries
2. Architecture mismatch (32-bit vs 64-bit)
3. Corrupted compiler installation

**Solution:**
```powershell
# Verify OpenSSL installation
dir "C:\OpenSSL-Win64\lib\*.lib"

# Should see:
# libssl.lib
# libcrypto.lib

# Clean and rebuild
.\Build-Installer.ps1 -Clean -Compiler gcc
```

#### Problem: "Inno Setup not found"

**Solution:**
```
1. Download Inno Setup 6 from:
   https://jrsoftware.org/isdl.php

2. Install to default location:
   C:\Program Files (x86)\Inno Setup 6

3. Run build again:
   .\Build-Installer.ps1
```

### Installation Issues

#### Problem: "Windows SmartScreen blocked"

**Solution:**
1. Right-click installer
2. Select "Properties"
3. Check "Unblock"
4. Click "Apply"
5. Run installer again

Or:
1. Click "More info"
2. Click "Run anyway"

#### Problem: "Access denied during installation"

**Solution:**
1. Right-click installer
2. Select "Run as administrator"
3. Click "Yes" on UAC prompt

#### Problem: "PATH not updated after installation"

**Solution:**
```powershell
# Restart PowerShell/CMD to reload PATH
# Or manually add to PATH:

$env:PATH += ";C:\Program Files\Levython\bin"

# Make permanent:
[Environment]::SetEnvironmentVariable(
    "Path",
    $env:PATH,
    "Machine"
)
```

#### Problem: "levython: command not found"

**Checklist:**
1. ✅ Installation completed successfully?
2. ✅ "Add to PATH" was selected during install?
3. ✅ Restarted terminal after installation?
4. ✅ Running with correct user account?

**Manual Fix:**
```batch
# Add to PATH manually
set PATH=%PATH%;C:\Program Files\Levython\bin

# Test
levython --version
```

### Runtime Issues

#### Problem: "VCRUNTIME140.dll missing"

**Solution:**
Install Visual C++ Redistributable:
```
https://aka.ms/vs/17/release/vc_redist.x64.exe
```

#### Problem: "libssl-3-x64.dll missing"

**Solution:**
```
This shouldn't happen with static builds.
If it does, reinstall with:
.\Build-Installer.ps1 -Clean
```

---

## ❓ FAQ

### General Questions

**Q: Which installation method should I use?**

A: For most users, use the **GUI installer** (`levython-1.0.3-windows-setup.exe`). It's the easiest and most feature-complete.

**Q: Can I install without administrator privileges?**

A: Yes, use the **portable package** or install to a user directory during GUI installation.

**Q: How much disk space is required?**

A: ~50-100 MB depending on components selected.

**Q: Does it work on Windows 7?**

A: Yes, Windows 7 SP1 and later are supported.

### Build Questions

**Q: How long does building take?**

A: 
- First build: 5-10 minutes
- Subsequent builds: 2-5 minutes
- With `-SkipBuild`: ~1 minute

**Q: Can I build for multiple architectures on one machine?**

A: Yes! Use `-Architecture all` to build both x64 and x86.

**Q: Which compiler is recommended?**

A: **MinGW-w64 GCC** is recommended for best compatibility. MSVC works great too if you have Visual Studio.

**Q: Do I need to rebuild for updates?**

A: Only if source code changes. Otherwise, use `-SkipBuild` to repackage.

### Installation Questions

**Q: Can I change the installation directory?**

A: Yes, during installation wizard or with silent install parameter:
```
/DIR="D:\MyPath\Levython"
```

**Q: Will it interfere with other Python installations?**

A: No, Levython is completely separate from Python.

**Q: Can I install multiple versions side-by-side?**

A: Yes, install to different directories.

**Q: How do I update Levython?**

A: Run the new installer. It will detect and offer to upgrade the existing installation.

### Feature Questions

**Q: What is NaN-boxing?**

A: An efficient value representation technique that stores type and value in a single 64-bit double, improving performance.

**Q: Does Levython have JIT compilation?**

A: Yes! Levython uses JIT-compiled bytecode VM for high performance.

**Q: Can I use Levython for production?**

A: Yes, Levython 1.0.3 is stable and production-ready.

**Q: Is there VS Code support?**

A: Yes! Syntax highlighting extension is included and can be installed automatically.

---

## 🎓 Advanced Topics

### CI/CD Integration

**GitHub Actions Example:**

```yaml
name: Build Levython Installer

on: [push, pull_request]

jobs:
  build:
    runs-on: windows-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Install Dependencies
      run: |
        choco install mingw -y
        choco install openssl -y
        choco install innosetup -y
    
    - name: Build Installer
      run: |
        cd installer
        .\Build-Installer.ps1 -Architecture all
      shell: powershell
    
    - name: Upload Artifacts
      uses: actions/upload-artifact@v3
      with:
        name: levython-installers
        path: releases/*
```

### Network Deployment

**Deploy to Multiple Computers:**

```powershell
$computers = @("PC1", "PC2", "PC3")
$installer = "\\server\share\levython-setup.exe"

foreach ($pc in $computers) {
    Invoke-Command -ComputerName $pc -ScriptBlock {
        param($installerPath)
        
        # Copy installer
        Copy-Item $installerPath -Destination "C:\Temp\"
        
        # Silent install
        Start-Process "C:\Temp\levython-setup.exe" `
            -ArgumentList "/VERYSILENT /NORESTART" `
            -Wait
        
        # Verify
        & "C:\Program Files\Levython\bin\levython.exe" --version
        
    } -ArgumentList $installer
}
```

### Custom Build Configurations

**Create Custom Build Profile:**

```powershell
# custom-build.ps1
param(
    [string]$Optimization = "aggressive"
)

$customFlags = switch ($Optimization) {
    "aggressive" {
        @("-O3", "-march=native", "-flto", "-ffast-math")
    }
    "size" {
        @("-Os", "-s", "-ffunction-sections", "-fdata-sections")
    }
    "debug" {
        @("-g", "-O0", "-DDEBUG")
    }
}

.\Build-Installer.ps1 -CustomFlags $customFlags
```

### Automated Testing

**Test Installation Script:**

```powershell
# test-installer.ps1

Write-Host "Testing Levython Installer..." -ForegroundColor Cyan

# Test 1: Build
Write-Host "[TEST] Building Levython..."
.\Build-Installer.ps1 -SkipInnoSetup
if ($LASTEXITCODE -ne 0) { throw "Build failed" }
Write-Host "[PASS] Build successful" -ForegroundColor Green

# Test 2: Executable
Write-Host "[TEST] Testing executable..."
$version = & ..\releases\levython-windows-x64.exe --version
if ($LASTEXITCODE -ne 0) { throw "Executable test failed" }
Write-Host "[PASS] Executable works: $version" -ForegroundColor Green

# Test 3: Package integrity
Write-Host "[TEST] Checking package..."
$zip = "..\releases\levython-1.0.3-windows-x64-portable.zip"
if (-not (Test-Path $zip)) { throw "Package not found" }
Write-Host "[PASS] Package exists" -ForegroundColor Green

Write-Host "`n[SUCCESS] All tests passed!" -ForegroundColor Green
```

---

## 🤝 Contributing

We welcome contributions to improve the installer system!

### Areas for Contribution

1. **UI/UX Improvements**
   - Enhanced installer themes
   - Better progress indicators
   - Improved error messages

2. **Build System**
   - Additional compiler support
   - Cross-compilation support
   - Build optimization

3. **Documentation**
   - Translation to other languages
   - Video tutorials
   - FAQ expansions

4. **Testing**
   - Test on different Windows versions
   - Compatibility testing
   - Performance benchmarks

### Contribution Process

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-installer`
3. Make changes and test thoroughly
4. Commit: `git commit -m "Add amazing installer feature"`
5. Push: `git push origin feature/amazing-installer`
6. Open Pull Request

### Code Style

- PowerShell: PascalCase for functions, clear comments
- Batch: REM comments, clear structure
- Inno Setup: Consistent indentation, section comments

---

## 📄 License

Same as Levython project - MIT License

---

## 🎖️ Credits

**Installer System:** Professional-grade automation and UI/UX  
**Build Tools:** PowerShell, Inno Setup, Batch scripting  
**Logo:** Integrated throughout for consistent branding  
**Testing:** Comprehensive validation on Windows 7-11  

**Special Thanks:**
- Inno Setup team for excellent installer framework
- MinGW-w64 project for GCC compiler
- OpenSSL team for cryptographic libraries
- All contributors and testers

---

## 📞 Support

- **Issues:** https://github.com/levython/levython/issues
- **Discussions:** https://github.com/levython/levython/discussions
- **Email:** levythonhq@gmail.com

---

## 🎯 Motto

> **"Be better than yesterday"**

Every build, every installation, every line of code - we strive for continuous improvement.

This installer represents our commitment to providing a **world-class installation experience** for Levython users.

---

**Version:** 2.0.0  
**Last Updated:** 2024  
**Build System:** PowerShell + Inno Setup  
**Quality:** Enhanced UI/UX ✨  
**Support:** levythonhq@gmail.com

---

**Built with ❤️ by the Levython Team**

*Making high-performance programming accessible to everyone.*