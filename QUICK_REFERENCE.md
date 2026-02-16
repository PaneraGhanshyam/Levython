# ⚡ Levython Installer - Quick Reference

**Fast Command Reference for Levython Installation**

> *"Be better than yesterday"*

---

## 🚀 Quick Install (End Users)

### GUI Installer (Recommended)
```batch
# Download and run
levython-1.0.3-windows-setup.exe
```

### Silent Install
```batch
# Completely silent
levython-1.0.3-windows-setup.exe /VERYSILENT /NORESTART

# Custom directory
levython-1.0.3-windows-setup.exe /VERYSILENT /DIR="D:\Levython"
```

### Portable Version
```batch
# Extract and run directly
levython.exe --version
```

---

## 🔨 Quick Build (Developers)

### Basic Build
```powershell
cd installer
.\Build-Installer.ps1
```

### All Architectures
```powershell
.\Build-Installer.ps1 -Architecture all
```

### Clean Build
```powershell
.\Build-Installer.ps1 -Clean
```

### Specific Compiler
```powershell
.\Build-Installer.ps1 -Compiler gcc    # MinGW
.\Build-Installer.ps1 -Compiler msvc   # Visual Studio
.\Build-Installer.ps1 -Compiler clang  # LLVM
```

### Skip Options
```powershell
.\Build-Installer.ps1 -SkipBuild         # Use existing binaries
.\Build-Installer.ps1 -SkipInnoSetup     # Skip GUI installer
```

---

## 📦 Batch Scripts

### Simple Build
```batch
cd installer
BUILD-SIMPLE.bat
```

### Multi-Architecture Build
```batch
build-both.bat
```

### Inno Setup Only
```batch
Build-InnoSetup.bat
```

### Interactive Install
```batch
Install-Levython.bat
```

---

## 🎯 Common Tasks

### Verify Installation
```bash
levython --version
levython --help
```

### Run REPL
```bash
levython
```

### Execute Script
```bash
levython script.levy
levython examples/01_hello_world.levy
```

### Check PATH
```powershell
$env:PATH -split ';' | Select-String Levython
```

### Manual PATH Add
```powershell
$env:PATH += ";C:\Program Files\Levython\bin"
```

---

## 🔧 Prerequisites

### Required
- Windows 7+
- PowerShell 5.1+
- C++ Compiler (GCC/MSVC/Clang)
- OpenSSL libraries

### Install OpenSSL
```powershell
# Chocolatey
choco install openssl

# vcpkg
vcpkg install openssl:x64-windows

# Or download from
# https://slproweb.com/products/Win32OpenSSL.html
```

### Install Compiler
```powershell
# MinGW via Chocolatey
choco install mingw

# Or download Visual Studio
# https://visualstudio.microsoft.com/
```

---

## 🐛 Quick Troubleshooting

### "Compiler not found"
```powershell
# Check if compiler exists
where g++
where cl
where clang++

# Install MinGW
choco install mingw
```

### "OpenSSL not found"
```powershell
# Set environment variable
$env:OPENSSL_DIR = "C:\OpenSSL-Win64"

# Or install
choco install openssl
```

### "levython: command not found"
```powershell
# Restart terminal to reload PATH
# Or manually add
$env:PATH += ";C:\Program Files\Levython\bin"
```

### "Access denied"
```batch
# Run as Administrator
# Right-click → Run as administrator
```

---

## 📁 Important Paths

### Default Installation
```
C:\Program Files\Levython\
├── bin\levython.exe
├── docs\
├── examples\
└── vscode-extension\
```

### Build Output
```
releases\
├── levython-windows-x64.exe
├── levython-1.0.3-windows-x64-portable.zip
└── levython-1.0.3-windows-setup.exe
```

---

## 🆘 Get Help

### Documentation
- `installer/README.md` - Overview
- `installer/INSTALLER_GUIDE.md` - Complete guide
- `installer/INSTALLER_UPDATES.md` - What's new

### Support
- **Email:** levythonhq@gmail.com
- **Issues:** https://github.com/levython/levython/issues
- **Releases:** https://github.com/levython/levython/releases

---

## 💡 Tips

- Use `-Clean` for first-time builds
- Run installer as Administrator for full features
- Restart terminal after PATH changes
- Use portable version for no-admin scenarios
- Silent install for automated deployments

---

## 📊 Build Options Reference

| Option | Description |
|--------|-------------|
| `-Architecture all` | Build x64 and x86 |
| `-Architecture x64` | Build x64 only |
| `-Compiler gcc` | Use MinGW GCC |
| `-Compiler msvc` | Use Visual Studio |
| `-Clean` | Clean build directories |
| `-SkipBuild` | Use existing binaries |
| `-SkipInnoSetup` | Skip GUI installer |

---

## 🌟 One-Liners

```powershell
# Complete build
cd installer; .\Build-Installer.ps1

# Quick test build
cd installer; .\BUILD-SIMPLE.bat

# Silent install
.\levython-setup.exe /VERYSILENT

# Verify install
levython --version

# Run example
levython examples/01_hello_world.levy
```

---

**Version:** 1.0.3  
**Support:** levythonhq@gmail.com  
**Motto:** Be better than yesterday

---

**Built with ❤️ by the Levython Team**