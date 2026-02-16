# 🚀 Levython Windows Installer

**Enhanced Installer System for Levython Programming Language**

> *"Be better than yesterday"* - Levython Motto

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Building the Installer](#building-the-installer)
- [Installer Types](#installer-types)
- [Build Options](#build-options)
- [Manual Installation](#manual-installation)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)
- [File Structure](#file-structure)

---

## 🎯 Overview

This directory contains the **installer system** for Levython on Windows. The system creates multiple installation formats:

- **GUI Installer** (Inno Setup) - Recommended for end users
- **Portable ZIP Packages** - For developers and portable installations
- **PowerShell Installer** - For automated deployments

---

## ✨ Features

### 🎨 Enhanced UI/UX
- Modern Windows 11/10 style interface
- Custom branding with Levython logo throughout
- Smooth animations and progress indicators
- Multi-language support (10+ languages)
- Enhanced console output with Unicode icons

### 🔧 Installation Features
- Automatic architecture detection (x64, x86, ARM64)
- Multi-compiler support (GCC, MSVC, Clang)
- OpenSSL auto-detection and integration
- Automatic PATH configuration
- File association for `.levy` and `.ly` files
- VS Code extension installation

### 🛡️ Quality Features
- Comprehensive error handling
- Build verification and validation
- Clean uninstallation
- Registry integration
- Environment variable management

---

## 📦 Prerequisites

### Required
- **Windows 7 or later** (Windows 10/11 recommended)
- **PowerShell 5.1+** (usually pre-installed on Windows 10/11)
- **C++ Compiler** (one of the following):
  - MinGW-w64: https://www.mingw-w64.org/
  - Visual Studio 2019+: https://visualstudio.microsoft.com/
  - LLVM/Clang: https://llvm.org/
- **OpenSSL** (libssl/libcrypto):
  - Download: https://slproweb.com/products/Win32OpenSSL.html
  - Or via vcpkg: `vcpkg install openssl`
  - Or via Chocolatey: `choco install openssl`

### Optional (for GUI installer)
- **Inno Setup 6.x**: https://jrsoftware.org/isdl.php

---

## 🚀 Quick Start

### For End Users

**Option 1: Download Installer** (Recommended)
```powershell
# Download the latest installer from releases
# https://github.com/levython/levython/releases

# Run the installer
.\levython-1.0.3-windows-setup.exe
```

**Option 2: Portable Version**
```powershell
# Download portable ZIP
# Extract and add to PATH, or run directly
levython.exe --version
```

### For Developers

**Build Everything:**
```powershell
cd installer
.\Build-Installer.ps1
```

This will:
1. ✅ Detect your system architecture
2. ✅ Find the best compiler
3. ✅ Locate OpenSSL
4. ✅ Compile Levython
5. ✅ Create portable packages
6. ✅ Build GUI installer

---

## 🔨 Building the Installer

### Basic Build

```powershell
# Build for current architecture
.\Build-Installer.ps1
```

### Build All Architectures

```powershell
# Build x64 and x86 versions
.\Build-Installer.ps1 -Architecture all
```

### Clean Build

```powershell
# Clean and rebuild
.\Build-Installer.ps1 -Clean
```

### Skip Compilation (Use Existing Binaries)

```powershell
# Only create installer packages from existing executables
.\Build-Installer.ps1 -SkipBuild
```

### Specify Compiler

```powershell
# Use specific compiler
.\Build-Installer.ps1 -Compiler msvc   # Visual Studio
.\Build-Installer.ps1 -Compiler gcc    # MinGW
.\Build-Installer.ps1 -Compiler clang  # LLVM Clang
```

---

## 📦 Installer Types

### Method 1: GUI Installer (Recommended)

**File:** `levython-1.0.3-windows-setup.exe`

**Features:**
- Beautiful modern UI with logo integration
- Automatic architecture detection
- Smart PATH configuration
- File association setup
- VS Code extension installation
- Multiple language support
- Clean uninstaller

**Usage:**
```powershell
.\levython-1.0.3-windows-setup.exe
```

**Silent Installation:**
```powershell
.\levython-1.0.3-windows-setup.exe /VERYSILENT /NORESTART
```

### 2. Portable Package

**File:** `levython-1.0.3-windows-x64-portable.zip`

**Features:**
- No installation required
- Perfect for USB drives
- Includes examples and documentation
- VS Code extension included

**Usage:**
```powershell
# Extract ZIP
Expand-Archive levython-1.0.3-windows-x64-portable.zip -DestinationPath C:\Levython

# Add to PATH (optional)
$env:PATH += ";C:\Levython"

# Run
levython.exe --version
```

### 3. PowerShell Installer

**File:** `LevythonInstaller.ps1`

**Features:**
- Automated deployment
- Network installation support
- CI/CD integration
- Customizable installation

**Usage:**
```powershell
.\LevythonInstaller.ps1
```

---

## ⚙️ Build Options

| Option | Description | Example |
|--------|-------------|---------|
| `-Architecture` | Target architecture: `auto`, `x64`, `x86`, `arm64`, `all` | `-Architecture all` |
| `-Compiler` | Preferred compiler: `auto`, `gcc`, `msvc`, `clang` | `-Compiler msvc` |
| `-SkipBuild` | Skip compilation, use existing binaries | `-SkipBuild` |
| `-SkipInnoSetup` | Skip GUI installer creation | `-SkipInnoSetup` |
| `-Clean` | Clean build directories before building | `-Clean` |

### Examples

```powershell
# Build everything with MSVC for all architectures
.\Build-Installer.ps1 -Architecture all -Compiler msvc -Clean

# Quick package from existing builds
.\Build-Installer.ps1 -SkipBuild

# Build portable packages only
.\Build-Installer.ps1 -SkipInnoSetup

# Build x86 version with GCC
.\Build-Installer.ps1 -Architecture x86 -Compiler gcc
```

---

## 🛠️ Manual Installation

If you prefer manual installation:

1. **Build the executable:**
   ```powershell
   cd src
   g++ -std=c++17 -O3 -DNDEBUG -static -o levython.exe levython.cpp -lssl -lcrypto -lws2_32 -lcrypt32
   ```

2. **Add to PATH:**
   ```powershell
   $env:PATH += ";C:\path\to\levython"
   [Environment]::SetEnvironmentVariable("Path", $env:PATH, "Machine")
   ```

3. **Create file associations (optional):**
   ```powershell
   cmd /c assoc .levy=LevythonScript
   cmd /c ftype LevythonScript="C:\path\to\levython.exe" "%1"
   ```

---

## 🔍 Troubleshooting

### Build Issues

**Problem: "No C++ compiler found"**
```
Solution: Install MinGW-w64, Visual Studio, or Clang
```

**Problem: "OpenSSL not found"**
```
Solution 1: Install OpenSSL from https://slproweb.com/products/Win32OpenSSL.html
Solution 2: Set OPENSSL_DIR environment variable
Solution 3: Use vcpkg: vcpkg install openssl
```

**Problem: "Build failed with linker errors"**
```
Solution: Ensure OpenSSL libraries (libssl.lib, libcrypto.lib) are accessible
```

### Installation Issues

**Problem: "Installer blocked by Windows SmartScreen"**
```
Solution: Right-click installer → Properties → Check "Unblock" → Apply
```

**Problem: "PATH not updated after installation"**
```
Solution: Restart terminal or log out/in for PATH changes to take effect
```

**Problem: "File associations not working"**
```
Solution: Reinstall with administrator privileges
```

### Runtime Issues

**Problem: "levython.exe - System Error: Missing DLL"**
```
Solution: Use static build or install Visual C++ Redistributable
```

---

## 🎓 Advanced Usage

### Custom Inno Setup Configuration

Edit `levython-setup.iss` to customize:
- Installation directory
- Start menu items
- File associations
- Registry keys
- Custom wizard pages

### CI/CD Integration

```yaml
# GitHub Actions Example
- name: Build Levython Installer
  run: |
    cd installer
    .\Build-Installer.ps1 -Architecture all -Clean
  shell: powershell

- name: Upload Artifacts
  uses: actions/upload-artifact@v3
  with:
    name: levython-installers
    path: releases/*.exe
```

### Network Deployment

```powershell
# Install on multiple machines
$computers = @("PC1", "PC2", "PC3")
foreach ($pc in $computers) {
    Copy-Item .\levython-setup.exe \\$pc\C$\Temp\
    Invoke-Command -ComputerName $pc -ScriptBlock {
        Start-Process "C:\Temp\levython-setup.exe" -ArgumentList "/VERYSILENT" -Wait
    }
}
```

---

## 📁 File Structure

```
installer/
├── README.md                    # This file
├── levython-setup.iss          # Inno Setup script (God-level UI/UX)
├── Build-Installer.ps1         # Professional build system
├── LevythonInstaller.ps1       # PowerShell installer
├── Install-Levython.bat        # Batch installer wrapper
├── BUILD-SIMPLE.bat            # Simple build script
├── build-both.bat              # Build both architectures
└── Build-Installer.ps1         # Main build orchestrator
```

---

## 📚 Additional Resources

- **Documentation:** https://github.com/levython/levython/wiki
- **Examples:** `../examples/`
- **Issue Tracker:** https://github.com/levython/levython/issues
- **Releases:** https://github.com/levython/levython/releases
- **Support:** levythonhq@gmail.com

---

## 🤝 Contributing

We welcome contributions to improve the installer system!

1. Fork the repository
2. Make your changes
3. Test thoroughly on different Windows versions
4. Submit a pull request

---

## 📄 License

Same as Levython main project - see `../LICENSE`

---

## 🎖️ Credits

**Build System:** PowerShell automation  
**Installer UI:** Inno Setup with custom branding  
**Logo Integration:** Seamless brand experience  
**Quality Assurance:** Tested on Windows 7-11  

---

## 💬 Motto

> **"Be better than yesterday"**

Every build, every installation, every line of code - we strive for continuous improvement.

---

**Built with ❤️ by the Levython Team**

*Making high-performance programming accessible to everyone.*

**Support:** levythonhq@gmail.com