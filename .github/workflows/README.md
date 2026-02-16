# GitHub Actions - Automated Release Pipeline

This directory contains GitHub Actions workflows for automated building, testing, and releasing of Levython across Windows, macOS, and Linux platforms.

## 📋 Overview

Two main workflows are provided:

1. **`release.yml`** - Automated multi-platform releases with installers
2. **`ci.yml`** - Continuous integration testing on every push/PR

## 🚀 Release Workflow (`release.yml`)

### Trigger Methods

#### Method 1: Tag-based Release (Recommended)
```bash
git tag v1.0.4
git push origin v1.0.4
```

This automatically triggers the release workflow and creates a GitHub release with all platform builds.

#### Method 2: Manual Dispatch
Go to GitHub Actions → "Build and Release" → "Run workflow" → Enter version manually

### What It Builds

| Platform | Artifacts | Description |
|----------|-----------|-------------|
| **Windows x64** | `Levython-Setup-x.x.x-x64.exe` | Professional Inno Setup installer with GUI |
| **Windows x64** | `Levython-Portable-x.x.x-x64-Windows.zip` | Portable ZIP package (no install needed) |
| **macOS Universal** | `Levython-x.x.x-macOS-Universal.dmg` | DMG disk image (Intel + Apple Silicon) |
| **macOS Universal** | `Levython-x.x.x-macOS-Universal.tar.gz` | Tarball with install script |
| **Linux x86_64** | `levython_x.x.x_amd64.deb` | Debian/Ubuntu package |
| **Linux x86_64** | `Levython-x.x.x-Linux-x86_64.tar.gz` | Tarball with install script |

### Windows Build Details

The Windows build includes:
- **MSYS2/MinGW64** environment setup
- **Clang** compiler for optimization
- **OpenSSL** linking for HTTPS support
- **Inno Setup 6** for professional installer creation
- **Custom branding** with logo integration
- **PATH configuration** automatic setup
- **File associations** for `.levy` and `.ly` files

The Inno Setup script (`installer/levython-setup.iss`) provides:
- Modern Windows UI with custom wizard pages
- Architecture detection (x64/x86/ARM64)
- VS Code extension installation option
- Multi-language support (10+ languages)
- Uninstaller with clean removal

### macOS Build Details

The macOS build creates:
- **Universal Binary** (both Intel x86_64 and Apple Silicon arm64)
- **DMG image** for drag-and-drop installation
- **Signed binaries** (if certificate provided)
- **Homebrew-compatible** structure

Features:
- OpenSSL@3 linking
- Framework integration (Security, CoreFoundation, CoreAudio)
- Install script for `/usr/local/bin`

### Linux Build Details

The Linux build produces:
- **DEB package** for Debian/Ubuntu systems
- **Tarball** for manual installation
- **System-wide installation** to `/usr/local/bin`

Dependencies included:
- OpenSSL (libssl-dev)
- ALSA (libasound2-dev)
- X11 libraries (libx11-dev, libxtst-dev)

### Release Assets

Every release includes:
- All platform-specific installers/packages
- `SHA256SUMS.txt` - Checksums for verification
- Auto-generated release notes
- Links to documentation and support

### Verification

After downloading, verify integrity:
```bash
# Linux/macOS
sha256sum -c SHA256SUMS.txt

# Windows (PowerShell)
Get-FileHash Levython-Setup-*.exe -Algorithm SHA256
```

## 🧪 CI Workflow (`ci.yml`)

### Purpose

Runs on every push and pull request to ensure builds work on all platforms.

### Triggers
- Push to `main`, `master`, or `develop` branches
- Pull requests targeting these branches

### What It Tests

For each platform (Windows, macOS, Linux):
1. ✅ Clean checkout
2. ✅ Dependency installation
3. ✅ Successful compilation
4. ✅ Binary creation
5. ✅ Version check
6. ✅ Example execution (if available)

### Build Matrix

| Platform | Runner | Compiler | Optimization |
|----------|--------|----------|--------------|
| Windows | windows-latest | Clang (MSYS2) | `-O2` |
| macOS | macos-latest | Clang | `-O2` |
| Linux | ubuntu-latest | Clang | `-O2` |

### Status Checks

The CI workflow provides:
- Per-platform status badges
- Combined summary check
- Automatic failure notifications

## 🔧 Configuration

### Environment Variables

Defined in workflows:
```yaml
env:
  APP_NAME: Levython
  APP_VERSION: ${{ github.event.inputs.version || github.ref_name }}
```

### Secrets Required

| Secret | Purpose | Required For |
|--------|---------|--------------|
| `GITHUB_TOKEN` | Release creation | Automatic (provided by GitHub) |

Optional secrets for enhanced features:
| Secret | Purpose | Setup Instructions |
|--------|---------|-------------------|
| `CODE_SIGN_CERT` | Windows code signing | Get from certificate authority |
| `APPLE_DEVELOPER_ID` | macOS signing | Apple Developer Program |
| `APPLE_DEVELOPER_PASSWORD` | macOS notarization | App-specific password |

### Adding Code Signing

#### Windows (Optional)
```yaml
- name: Sign Windows Executable
  run: |
    signtool sign /f cert.pfx /p ${{ secrets.CERT_PASSWORD }} levython.exe
```

#### macOS (Optional)
```yaml
- name: Sign macOS Binary
  run: |
    codesign --sign "${{ secrets.APPLE_DEVELOPER_ID }}" levython
```

## 📦 Manual Release Process

If you prefer manual releases:

1. **Build locally** on each platform
2. **Test thoroughly**
3. **Create release** on GitHub
4. **Upload artifacts** manually

```bash
# Tag the release
git tag v1.0.4
git push origin v1.0.4

# Build on Windows
cd installer
./Build-InnoSetup.bat

# Build on macOS
make clean && make

# Build on Linux
make clean && make
```

## 🐛 Troubleshooting

### Build Failures

**Windows: "OpenSSL not found"**
```yaml
# Ensure MSYS2 package is installed
install: mingw-w64-x86_64-openssl
```

**macOS: "Framework not found"**
```bash
# Install Xcode Command Line Tools
xcode-select --install
```

**Linux: "Missing library"**
```bash
# Install required dependencies
sudo apt-get install libssl-dev libasound2-dev libx11-dev libxtst-dev
```

### Inno Setup Issues

**"ISCC not found"**
- Verify installation path: `C:\Program Files (x86)\Inno Setup 6\`
- Check PATH environment variable

**"Logo not found"**
- Ensure `icon.png` exists in project root
- Update path in `levython-setup.iss`

### Release Creation Fails

**"Permission denied"**
- Check repository settings → Actions → General
- Enable "Read and write permissions" for workflows

**"Artifacts not uploaded"**
- Verify artifact paths match build output
- Check artifact retention settings

## 📊 Monitoring

### View Workflow Status

1. Go to your repository on GitHub
2. Click **Actions** tab
3. Select workflow run
4. View logs for each job

### Status Badges

Add to your README.md:
```markdown
![Release](https://github.com/levython/Levython/actions/workflows/release.yml/badge.svg)
![CI](https://github.com/levython/Levython/actions/workflows/ci.yml/badge.svg)
```

## 🔄 Workflow Maintenance

### Updating Dependencies

**MSYS2 packages** (Windows):
```yaml
install: >-
  mingw-w64-x86_64-gcc
  mingw-w64-x86_64-clang
  mingw-w64-x86_64-openssl
```

**Homebrew packages** (macOS):
```bash
brew install openssl@3
```

**APT packages** (Linux):
```bash
sudo apt-get install libssl-dev libasound2-dev
```

### Upgrading Actions

Keep actions up to date:
```yaml
uses: actions/checkout@v4  # Check for v5, v6, etc.
uses: actions/upload-artifact@v4
uses: actions/download-artifact@v4
```

## 📝 Best Practices

1. **Version Consistency**: Ensure version matches across:
   - Git tag (`v1.0.4`)
   - `installer/levython-setup.iss` (`#define MyAppVersion`)
   - Documentation files

2. **Testing**: Always test locally before pushing tags

3. **Changelogs**: Update `CHANGELOG.md` before releases

4. **Documentation**: Keep installer docs in sync with code

5. **Security**: Never commit secrets or API keys

## 🆘 Support

For issues with GitHub Actions:
- **Repository Issues**: https://github.com/levython/levython/issues
- **Email Support**: levythonhq@gmail.com
- **Actions Documentation**: https://docs.github.com/en/actions

## 📚 Additional Resources

- [Inno Setup Documentation](https://jrsoftware.org/isinfo.php)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [MSYS2 Packages](https://packages.msys2.org/)
- [Homebrew Formulae](https://formulae.brew.sh/)

---

**Last Updated**: January 2025  
**Workflow Version**: 1.0  
**Maintainer**: Levython Team