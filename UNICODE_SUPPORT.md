# Unicode and Character Encoding Support

## Overview

Levython now includes **full Unicode and UTF-8 character encoding support** across all platforms, ensuring that international characters, emojis, symbols, and special characters display correctly on Windows, Unix, Linux, and macOS.

## Features

### ✓ Cross-Platform UTF-8 Support
- Automatic UTF-8 console initialization on Windows
- Native UTF-8 support on Unix, Linux, and macOS
- Consistent character rendering across all platforms

### ✓ Windows Console Enhancements
- **Automatic Code Page Configuration**: Sets console to UTF-8 (CP 65001)
- **ANSI Escape Sequence Support**: Enables colored terminal output
- **Virtual Terminal Processing**: Modern terminal features on Windows 10+
- **Locale Configuration**: Proper locale setup for international text

### ✓ UTF-8 Validation and Sanitization
- Validates UTF-8 byte sequences
- Automatically replaces invalid sequences with replacement character (�)
- Prevents encoding-related crashes

### ✓ BOM (Byte Order Mark) Handling
- Automatically detects and removes UTF-8 BOM (EF BB BF)
- Ensures clean file reading across different editors
- Optional BOM writing for Windows compatibility

### ✓ Safe Output Functions
- `encoding::safe_print()` - UTF-8 safe console output
- `encoding::safe_error()` - UTF-8 safe error output
- Automatic sanitization of invalid UTF-8 sequences

## Implementation Details

### Initialization

Unicode support is automatically initialized when Levython starts:

```cpp
int main(int argc, char* argv[]) {
    // Initialize Unicode/UTF-8 support for console output
    encoding::initialize_console_encoding();
    
    // ... rest of main
}
```

The `Interpreter` class also initializes encoding:

```cpp
Interpreter() {
    // Initialize Unicode/UTF-8 console support
    encoding::initialize_console_encoding();
    
    // ... rest of constructor
}
```

### Windows-Specific Setup

On Windows, the following operations are performed:

1. **Console Code Page Configuration**
   ```cpp
   SetConsoleOutputCP(CP_UTF8);  // Set output to UTF-8
   SetConsoleCP(CP_UTF8);         // Set input to UTF-8
   ```

2. **Virtual Terminal Processing**
   ```cpp
   DWORD dwMode = 0;
   GetConsoleMode(hOut, &dwMode);
   dwMode |= ENABLE_VIRTUAL_TERMINAL_PROCESSING;
   SetConsoleMode(hOut, dwMode);
   ```

3. **Input Mode Enhancement**
   ```cpp
   dwMode |= ENABLE_VIRTUAL_TERMINAL_INPUT;
   SetConsoleMode(hIn, dwMode);
   ```

### Unix/Linux/macOS Setup

On Unix-like systems:

1. **Locale Configuration**
   ```cpp
   setlocale(LC_ALL, "");
   setlocale(LC_CTYPE, "en_US.UTF-8");
   ```

2. **Fallback Locales**
   - Attempts multiple UTF-8 locales: `en_US.UTF-8`, `C.UTF-8`, `en_GB.UTF-8`, etc.

### File I/O

#### Reading Files with UTF-8 Support

```cpp
std::string code = encoding::read_file_utf8(filename);
```

Features:
- Binary mode reading for accurate byte handling
- Automatic BOM removal
- UTF-8 validation and sanitization

#### Writing Files with UTF-8 Support

```cpp
encoding::write_file_utf8(filename, content, add_bom);
```

Features:
- Binary mode writing
- Optional BOM addition for Windows compatibility
- Ensures proper UTF-8 encoding

### UTF-8 Validation

The `is_valid_utf8()` function validates UTF-8 byte sequences:

- **1-byte sequences**: `0xxxxxxx` (ASCII)
- **2-byte sequences**: `110xxxxx 10xxxxxx`
- **3-byte sequences**: `1110xxxx 10xxxxxx 10xxxxxx`
- **4-byte sequences**: `11110xxx 10xxxxxx 10xxxxxx 10xxxxxx`

### UTF-8 Sanitization

The `sanitize_utf8()` function:
- Validates each character sequence
- Replaces invalid sequences with � (U+FFFD - Replacement Character)
- Preserves valid UTF-8 characters

## Usage in Levython

### Basic Unicode Output

```levython
# ASCII characters
say("Hello, World!")

# Unicode characters
say("Hello 世界")
say("Привет мир")
say("مرحبا بالعالم")

# Emojis
say("🚀 Levython is awesome! 🎉")
```

### International Text

```levython
# Multiple languages
say("English: Hello")
say("Spanish: Hola")
say("French: Bonjour")
say("German: Guten Tag")
say("Russian: Здравствуйте")
say("Chinese: 你好")
say("Japanese: こんにちは")
say("Korean: 안녕하세요")
say("Arabic: مرحبا")
say("Hebrew: שלום")
say("Hindi: नमस्ते")
```

### Box Drawing and Line Art

```levython
say("┌─────────────────┐")
say("│  Levython Demo  │")
say("├─────────────────┤")
say("│  ✓ UTF-8 Ready  │")
say("└─────────────────┘")
```

### Mathematical Symbols

```levython
say("Greek: α β γ δ ε ζ η θ")
say("Math: ∑ ∏ ∫ ∂ ∇ √ ∞")
say("Logic: ∧ ∨ ¬ → ↔ ⇒")
```

### Emojis and Symbols

```levython
say("Weather: ☀ ☁ ☂ ⛄ ❄")
say("Hearts: ❤️ 💙 💚 💛 🧡 💜")
say("Stars: ⭐ ✨ 💫 ⚡ 🌟")
```

## Testing

Run the included Unicode demo:

```bash
./levython examples/53_unicode_demo.levy
```

This comprehensive test includes:
- ASCII character display
- International language text
- Emoji rendering
- Mathematical symbols
- Box drawing characters
- Currency symbols
- Technical symbols
- Unicode line art

## Platform-Specific Notes

### Windows

**Requirements:**
- Windows 10 version 1511 or later (for full ANSI support)
- Windows Terminal or modern console host recommended

**Known Issues:**
- Legacy console (cmd.exe on older Windows) may have limited emoji support
- Use Windows Terminal for best Unicode experience

**Registry Settings (Optional):**
Some older Windows systems may need:
```
[HKEY_CURRENT_USER\Console]
"CodePage"=dword:0000fde9
```

### Unix/Linux

**Requirements:**
- UTF-8 locale installed (usually default)
- Terminal emulator with UTF-8 support

**Verify Locale:**
```bash
locale charmap
# Should output: UTF-8
```

**Install UTF-8 Locale (if needed):**
```bash
# Debian/Ubuntu
sudo locale-gen en_US.UTF-8

# Fedora/RHEL
sudo dnf install glibc-langpack-en
```

### macOS

**Requirements:**
- macOS 10.3+ (native UTF-8 support)
- Any terminal emulator (Terminal.app, iTerm2, etc.)

**Verification:**
UTF-8 is default on macOS; no configuration needed.

## API Reference

### C++ API

#### `encoding::initialize_console_encoding()`
Initializes console for UTF-8 output. Called automatically at startup.

#### `encoding::is_valid_utf8(const std::string& str)`
Validates if a string contains valid UTF-8 encoding.

**Returns:** `bool` - true if valid, false otherwise

#### `encoding::sanitize_utf8(const std::string& str)`
Ensures string is valid UTF-8, replacing invalid sequences.

**Returns:** `std::string` - sanitized UTF-8 string

#### `encoding::safe_print(const std::string& str)`
Cross-platform safe console output with UTF-8 support.

#### `encoding::safe_error(const std::string& str)`
Cross-platform safe error output with UTF-8 support.

#### `encoding::remove_utf8_bom(const std::string& str)`
Removes UTF-8 BOM (EF BB BF) from string beginning.

**Returns:** `std::string` - string without BOM

#### `encoding::read_file_utf8(const std::string& filename)`
Reads file with UTF-8 support, handles BOM, validates encoding.

**Returns:** `std::string` - file contents as valid UTF-8

**Throws:** `std::runtime_error` if file cannot be opened

#### `encoding::write_file_utf8(const std::string& filename, const std::string& content, bool add_bom = false)`
Writes file with UTF-8 encoding, optionally adds BOM.

**Parameters:**
- `filename` - output file path
- `content` - UTF-8 string to write
- `add_bom` - if true, adds UTF-8 BOM (default: false)

**Throws:** `std::runtime_error` if file cannot be opened

## Troubleshooting

### Characters Display as Question Marks

**Windows:**
1. Ensure you're using Windows Terminal or modern console
2. Check console font supports Unicode (e.g., Cascadia Code, Consolas)
3. Verify UTF-8 code page: `chcp` should show 65001

**Linux:**
1. Check locale: `echo $LANG` should end with `.UTF-8`
2. Install locale: `sudo locale-gen en_US.UTF-8`
3. Set locale: `export LANG=en_US.UTF-8`

**macOS:**
1. Usually works by default
2. Check Terminal settings: Preferences → Profiles → Text → Character encoding (should be UTF-8)

### Emojis Not Displaying

**Windows:**
- Use Windows Terminal instead of cmd.exe
- Install a font with emoji support (Segoe UI Emoji, Noto Color Emoji)

**Linux:**
- Install emoji fonts: `sudo apt install fonts-noto-color-emoji`
- Restart terminal after font installation

**macOS:**
- Emojis should work by default with system fonts

### File Reading Issues

**BOM Problems:**
- Levython automatically handles UTF-8 BOM
- Files saved with BOM in Windows editors will work correctly

**Encoding Errors:**
- Files must be saved as UTF-8 (not UTF-16 or other encodings)
- Use `encoding::read_file_utf8()` for guaranteed UTF-8 handling

## Best Practices

1. **Always Use UTF-8**
   - Save source files as UTF-8 without BOM (preferred)
   - UTF-8 with BOM is also supported

2. **Test on Target Platform**
   - Verify Unicode display on Windows if that's your target
   - Test with actual emoji/international text

3. **Font Selection**
   - Use Unicode-compatible fonts (Cascadia Code, Fira Code, JetBrains Mono)
   - Ensure emoji support if using emojis

4. **Terminal Selection**
   - Windows: Use Windows Terminal
   - Linux: Most modern terminals work (GNOME Terminal, Konsole, etc.)
   - macOS: Terminal.app or iTerm2

5. **Validation**
   - Use `encoding::is_valid_utf8()` when reading external data
   - Sanitize user input with `encoding::sanitize_utf8()`

## Examples

See `examples/53_unicode_demo.levy` for a comprehensive demonstration of Unicode support including:

- ASCII and Unicode text
- International languages
- Emojis and symbols
- Box drawing characters
- Mathematical notation
- Currency symbols
- Line art

## Technical Details

### UTF-8 Byte Sequences

| Code Points       | Bytes | Representation                                    |
|-------------------|-------|---------------------------------------------------|
| U+0000 - U+007F   | 1     | 0xxxxxxx                                          |
| U+0080 - U+07FF   | 2     | 110xxxxx 10xxxxxx                                 |
| U+0800 - U+FFFF   | 3     | 1110xxxx 10xxxxxx 10xxxxxx                        |
| U+10000 - U+10FFFF| 4     | 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx               |

### Replacement Character

Invalid UTF-8 sequences are replaced with:
- **Character**: � (Replacement Character)
- **Code Point**: U+FFFD
- **UTF-8 Bytes**: EF BB BD

### BOM (Byte Order Mark)

- **Bytes**: EF BB BF
- **Purpose**: Indicates UTF-8 encoding
- **Levython Behavior**: Automatically removed when reading files

## Performance

Unicode support has minimal performance impact:
- UTF-8 validation: O(n) where n is string length
- Sanitization: Only performed when needed
- Console output: Native system calls, no overhead
- File I/O: Binary mode for efficiency

## Future Enhancements

Planned improvements:
- [ ] UTF-16 support for Windows-specific APIs
- [ ] Grapheme cluster handling for complex scripts
- [ ] Normalization forms (NFC, NFD, NFKC, NFKD)
- [ ] Bidirectional text support (RTL languages)
- [ ] Unicode collation and sorting

## References

- [UTF-8 Specification (RFC 3629)](https://www.rfc-editor.org/rfc/rfc3629)
- [Unicode Standard](https://www.unicode.org/versions/latest/)
- [Windows Console UTF-8](https://docs.microsoft.com/en-us/windows/console/)
- [POSIX Locale Support](https://pubs.opengroup.org/onlinepubs/9699919799/)

## License

This Unicode support implementation is part of Levython and is licensed under the MIT License.

---

**Levython** - Be better than yesterday! 🚀