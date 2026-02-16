# GitHub Actions - Professional Release Automation

## 🎉 Welcome!

Your Levython project now has a **fully automated, professional-grade release pipeline** that builds installers and packages for Windows, macOS, and Linux with a single command!

---

## 📁 What's Included

```
.github/
├── workflows/
│   ├── release.yml       # Automated multi-platform releases
│   ├── ci.yml            # Continuous integration testing
│   └── README.md         # Detailed workflow documentation
├── BADGES.md             # Status badges for your README
├── RELEASE_GUIDE.md      # Complete release guide
├── QUICK_START.md        # One-page quick reference
└── README.md             # This file
```

---

## 🚀 Quick Start

### Create a Release in 2 Commands

```bash
git tag v1.0.4
git push origin v1.0.4
```

**Done!** GitHub Actions automatically:
- ✅ Builds for Windows, macOS, and Linux
- ✅ Creates professional installers (Inno Setup, DMG, DEB)
- ✅ Generates portable packages
- ✅ Calculates SHA256 checksums
- ✅ Creates GitHub release with all artifacts
- ✅ Auto-generates release notes

**Total time**: 15-20 minutes

---

## 📦 Release Artifacts

Every release automatically creates:

### Windows (x64)
- **`Levython-Setup-x.x.x-x64.exe`** - Professional Inno Setup installer
  - GUI wizard with logo and branding
  - Automatic PATH configuration
  - File associations (.levy, .ly)
  - VS Code extension support
  - Multi-language support (10+ languages)
  - Clean uninstaller

- **`Levython-Portable-x.x.x-x64-Windows.zip`** - Portable package
  - No installation required
  - Extract and run

### macOS (Universal Binary)
- **`Levython-x.x.x-macOS-Universal.dmg`** - Disk image
  - Works on Intel and Apple Silicon
  - Drag-and-drop installation
  - Professional packaging

- **`Levython-x.x.x-macOS-Universal.tar.gz`** - Tarball
  - Includes install script
  - Command-line installation

### Linux (x86_64)
- **`levython_x.x.x_amd64.deb`** - Debian package
  - One-command install: `sudo dpkg -i levython_x.x.x_amd64.deb`
  - Works on Debian, Ubuntu, Mint, Pop!_OS, etc.

- **`Levython-x.x.x-Linux-x86_64.tar.gz`** - Tarball
  - Works on any Linux distribution
  - Includes install script

### All Platforms
- **`SHA256SUMS.txt`** - Checksums for verification
- **Auto-generated release notes** with installation instructions

---

## ✅ First-Time Setup

### 1. Enable Workflow Permissions (Required)

1. Go to your repository **Settings**
2. Click **Actions** → **General**
3. Scroll to "Workflow permissions"
4. Select **"Read and write permissions"**
5. Click **Save**

### 2. Verify Files Exist

```bash
# Check required files
ls -l installer/levython-setup.iss
ls -l icon.png
ls -l Makefile
ls -l src/levython.cpp
```

### 3. Update Version (Before Each Release)

Edit `installer/levython-setup.iss`:
```iss
#define MyAppVersion "1.0.4"  ; Update this
```

### 4. Create Your First Release

```bash
git tag v1.0.4
git push origin v1.0.4
```

---

## 🔄 Two Ways to Release

### Method 1: Tag-Based (Recommended) ⭐

```bash
# Tag your release
git tag v1.0.4

# Push the tag
git push origin v1.0.4
```

Workflow automatically triggers on tag push.

### Method 2: Manual Trigger

1. Go to GitHub → **Actions** tab
2. Select **"Build and Release"** workflow
3. Click **"Run workflow"** button
4. Enter version number (e.g., `1.0.4`)
5. Click **"Run workflow"**

---

## 📊 Build Process

### Workflow Jobs (Run in Parallel)

1. **build-windows** (~7 minutes)
   - Setup MSYS2/MinGW64
   - Compile with Clang + OpenSSL
   - Install Inno Setup 6
   - Build professional installer
   - Create portable ZIP

2. **build-macos** (~8 minutes)
   - Build x86_64 binary (Intel)
   - Build arm64 binary (Apple Silicon)
   - Create universal binary
   - Package as DMG
   - Create tarball

3. **build-linux** (~5 minutes)
   - Install dependencies (OpenSSL, ALSA, X11)
   - Compile with Clang
   - Build DEB package
   - Create tarball

4. **create-release** (~2 minutes)
   - Collect all artifacts
   - Generate SHA256 checksums
   - Create release notes
   - Upload to GitHub Releases

**Total Time**: ~15-20 minutes

---

## 🎯 Continuous Integration

The **CI workflow** (`ci.yml`) runs automatically on:
- Every push to `main`, `master`, or `develop`
- Every pull request

It tests builds on all three platforms to catch issues early.

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| **Workflow not triggering** | Ensure you pushed the tag: `git push origin v1.0.4` |
| **Permission denied** | Enable "Read and write permissions" in repository Settings → Actions |
| **Windows build fails** | Check `levython-setup.iss` syntax and verify Inno Setup installation |
| **macOS build fails** | Verify OpenSSL installation and framework links in Makefile |
| **Linux build fails** | Check dependency installation in workflow logs |
| **Artifacts not uploaded** | Review build logs for errors in each platform job |

---

## 📝 Pre-Release Checklist

Before creating a release:

- [ ] Update version in `installer/levython-setup.iss`
- [ ] Update `CHANGELOG.md` with new features
- [ ] Commit and push all changes
- [ ] Test build locally (optional but recommended)
- [ ] Verify `icon.png` exists in project root
- [ ] Ensure examples directory has working samples

Then:
```bash
git tag v1.0.4
git push origin v1.0.4
```

---

## 🎨 Customization

### Change App Details

Edit `installer/levython-setup.iss`:
```iss
#define MyAppName "Your App Name"
#define MyAppVersion "1.0.4"
#define MyAppPublisher "Your Company"
#define MyAppURL "https://yourwebsite.com"
```

### Update Branding

1. Replace `icon.png` with your logo
2. Update Inno Setup script references:
   ```iss
   SetupIconFile=..\your-icon.ico
   WizardImageFile=..\your-logo.bmp
   ```

### Add More Languages

Edit `installer/levython-setup.iss`:
```iss
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
```

### Modify Release Notes

Edit `.github/workflows/release.yml` in the "Generate Release Notes" step.

---

## 🎓 Advanced Features

### Add Status Badges to README

```markdown
[![Release](https://github.com/levython/Levython/actions/workflows/release.yml/badge.svg)](https://github.com/levython/Levython/actions/workflows/release.yml)
[![CI](https://github.com/levython/Levython/actions/workflows/ci.yml/badge.svg)](https://github.com/levython/Levython/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/github/v/release/levython/Levython)](https://github.com/levython/Levython/releases/latest)
```

Replace `levython` with your GitHub username.

### Code Signing (Optional)

For production releases, add code signing:

**Windows**: Requires code signing certificate  
**macOS**: Requires Apple Developer Program membership ($99/year)

See `workflows/README.md` for detailed instructions.

---

## 📚 Documentation

Comprehensive documentation is available:

1. **[QUICK_START.md](QUICK_START.md)** - One-page quick reference
2. **[RELEASE_GUIDE.md](RELEASE_GUIDE.md)** - Complete release guide with examples
3. **[workflows/README.md](workflows/README.md)** - Detailed workflow documentation
4. **[BADGES.md](BADGES.md)** - Status badge templates and examples
5. **[../GITHUB_ACTIONS_SETUP.md](../GITHUB_ACTIONS_SETUP.md)** - Full setup summary

---

## 💡 Tips & Best Practices

1. **Test locally first** - Build on at least one platform before releasing
2. **Use semantic versioning** - Follow `MAJOR.MINOR.PATCH` format
3. **Update changelogs** - Keep `CHANGELOG.md` current
4. **Test releases** - Use test tags like `v1.0.4-test` before final release
5. **Monitor builds** - Check Actions tab for any failures
6. **Verify downloads** - Test installers on actual target systems
7. **Keep docs in sync** - Update documentation with each release

---

## ⚡ Common Commands

```bash
# Create and push release tag
git tag v1.0.4 && git push origin v1.0.4

# List all tags
git tag -l

# Delete local tag
git tag -d v1.0.4

# Delete remote tag
git push origin :refs/tags/v1.0.4

# View release on GitHub (requires gh CLI)
gh release view v1.0.4 --web

# Download release assets (requires gh CLI)
gh release download v1.0.4
```

---

## 🔐 Security Best Practices

1. **Never commit secrets** to the repository
2. **Use GitHub Secrets** for sensitive data (Settings → Secrets and variables → Actions)
3. **Verify checksums** before distributing releases
4. **Enable branch protection** for main/master branches
5. **Review workflow changes** in pull requests carefully

---

## 📧 Support

For help with GitHub Actions:

- **Email**: levythonhq@gmail.com
- **GitHub Issues**: Open an issue in your repository
- **Workflow Logs**: Check Actions tab for detailed error messages
- **GitHub Docs**: https://docs.github.com/en/actions

---

## 🎉 Summary

You now have:

✅ **Automated releases** - One command to release on all platforms  
✅ **Professional installers** - Inno Setup, DMG, and DEB packages  
✅ **Quality assurance** - CI tests on every commit  
✅ **Zero maintenance** - Runs on GitHub's infrastructure  
✅ **Production ready** - Used by thousands of projects  

---

## 🚀 Ready to Release?

```bash
# 1. Update version in installer/levython-setup.iss
# 2. Commit your changes
git add .
git commit -m "Prepare v1.0.4 release"
git push

# 3. Create and push release tag
git tag v1.0.4
git push origin v1.0.4

# 4. Watch the magic happen! ✨
# Go to: https://github.com/levython/Levython/actions
```

---

**Made with ❤️ for Levython**  
**Last Updated**: January 2025  
**Version**: 1.0

For questions or issues, contact: **levythonhq@gmail.com**