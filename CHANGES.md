# Levython Changelog

## Latest Changes

### 🎨 New Feature: Built-in Color Module

Added a comprehensive color module with ANSI terminal color support, similar to Python's `colorama` but built directly into Levython!

#### Features:
- **8 Basic Colors**: red, green, yellow, blue, magenta, cyan, white, black
- **7 Bright Colors**: bright_red, bright_green, bright_yellow, bright_blue, bright_magenta, bright_cyan, bright_white
- **8 Background Colors**: bg_red, bg_green, bg_yellow, bg_blue, bg_magenta, bg_cyan, bg_white, bg_black
- **7 Text Styles**: bold, dim, italic, underline, blink, reverse, hidden
- **24-bit RGB Support**: rgb(r, g, b, text) and bg_rgb(r, g, b, text) for custom colors
- **Utility Functions**: reset(), colorize(text, color_name)
- **Color Constants**: Direct access to ANSI codes (color.RED, color.GREEN, etc.)

#### Usage:
```levy
import color

# Basic colors
say(color.red("Error message"))
say(color.green("Success!"))
say(color.yellow("Warning"))

# Combine styles
say(color.bold(color.blue("Important information")))

# RGB custom colors
say(color.rgb(255, 100, 0, "Custom orange color"))

# Background colors
say(color.bg_blue(color.white("White text on blue")))
```

#### Examples:
- **examples/color_demo.levy** - Comprehensive showcase of all color features
- **examples/snake.levy** - Updated with colorful graphics using the color module

#### Documentation:
- **COLOR_MODULE.md** - Full API reference and usage guide

---

### ⚙️ Build System Improvements

#### Native vs Cross-Platform Compilation
The build system now intelligently determines when to use native compilation vs cross-compilation:

- **Native Builds**: When building for the current platform (or `--target native`), uses the Levython compiler directly without requiring Zig
- **Cross-Platform Builds**: Only uses Zig when explicitly targeting a different platform (e.g., building Windows binaries on macOS)

#### Platform Detection
Automatic platform detection ensures:
- Building on macOS for macOS → Native compilation (no Zig needed)
- Building on Linux for Linux → Native compilation (no Zig needed)
- Building on Windows for Windows → Native compilation (no Zig needed)
- Building for a different platform → Cross-compilation with Zig

#### Bug Fixes
- Fixed runtime executable path resolution when `levython` is in PATH
- Improved error messages for build failures
- Added verbose mode output showing compilation method used

#### Usage:
```bash
# Native build (no Zig required)
levython build app.levy -o app

# Cross-compile to Windows (requires Zig)
levython build app.levy --target windows -o app.exe

# Cross-compile to Linux (requires Zig)
levython build app.levy --target linux -o app-linux

# Verbose output
levython build app.levy -o app --verbose
```

#### Benefits:
- ✅ Faster native builds (no Zig overhead)
- ✅ Simpler setup for single-platform development
- ✅ Zig only required for actual cross-compilation
- ✅ Better error messages and diagnostics
- ✅ Clear indication of compilation method used

---

### 📝 Output Improvements

Build command now shows:
```
✓ Built standalone executable: app
  Target platform: x86_64-macos
  Compilation method: Native (Levython)
```

Or for cross-compilation:
```
✓ Built standalone executable: app.exe
  Target platform: x86_64-windows-gnu
  Compilation method: Cross-compiled (Zig)
```

---

## Implementation Details

### Color Module Architecture
- **Namespace**: `color_bindings`
- **Location**: Integrated into `src/levython.cpp`
- **ANSI Codes**: Standard ANSI escape sequences for maximum compatibility
- **Auto-reset**: Color functions with text arguments automatically reset after the text
- **Manual Control**: Call without arguments to get raw ANSI codes for manual styling

### Build System Changes
- Added `resolve_executable_path()` function to find levython in PATH
- Added `get_current_platform()` to detect the current OS
- Modified `build_runtime_for_target()` to compare target vs current platform
- Updated help text to clarify native vs cross-compilation behavior

---

## Files Modified

### Core Files:
- `src/levython.cpp` - Added color module (340+ lines) and build system improvements

### Documentation:
- `COLOR_MODULE.md` - Complete color module documentation
- `CHANGES.md` - This changelog

### Examples:
- `examples/snake.levy` - Enhanced with colorful UI
- `examples/color_demo.levy` - Comprehensive color showcase (249 lines)

---

## Compatibility

### Color Module:
- **Linux/macOS**: Full support in most terminals
- **Windows**: Works in Windows Terminal, PowerShell 7+, and terminals with ANSI support
- **Classic CMD**: Requires Windows 10+ for proper color display

### Build System:
- Backward compatible with existing build commands
- `--target native` behavior unchanged
- Zig still required for cross-platform builds

---

## Future Enhancements

Potential future additions to the color module:
- 256-color palette support
- Gradients and color transitions
- Terminal capability detection
- Color themes/presets
- More ASCII art helpers

---

**Version**: Latest development build  
**Date**: 2024-01-15  
**Features Added**: Color Module, Build System Improvements  
**Lines Added**: 600+ lines of new functionality