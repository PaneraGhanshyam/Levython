# Color Module Documentation

The `color` module provides built-in ANSI color support for terminal output, similar to Python's `colorama` but integrated directly into Levython.

## Import

```levy
import color
```

## Basic Colors

### Foreground Colors
Apply colors to text. Can be called with or without arguments:

```levy
# With text (auto-resets after)
say(color.red("This is red text"))
say(color.green("This is green text"))
say(color.yellow("This is yellow text"))
say(color.blue("This is blue text"))
say(color.magenta("This is magenta text"))
say(color.cyan("This is cyan text"))
say(color.white("This is white text"))
say(color.black("This is black text"))

# Without text (returns ANSI code only)
text <- color.red() + "Red text" + color.reset()
```

### Bright Colors
Brighter, more vivid versions of basic colors:

```levy
say(color.bright_red("Bright red text"))
say(color.bright_green("Bright green text"))
say(color.bright_yellow("Bright yellow text"))
say(color.bright_blue("Bright blue text"))
say(color.bright_magenta("Bright magenta text"))
say(color.bright_cyan("Bright cyan text"))
say(color.bright_white("Bright white text"))
```

## Background Colors

Apply background colors to text:

```levy
say(color.bg_red("Red background"))
say(color.bg_green("Green background"))
say(color.bg_yellow("Yellow background"))
say(color.bg_blue("Blue background"))
say(color.bg_magenta("Magenta background"))
say(color.bg_cyan("Cyan background"))
say(color.bg_white("White background"))
say(color.bg_black("Black background"))
```

## Text Styles

Apply various text formatting styles:

```levy
say(color.bold("Bold text"))
say(color.dim("Dimmed text"))
say(color.italic("Italic text"))
say(color.underline("Underlined text"))
say(color.blink("Blinking text"))
say(color.reverse("Reversed colors"))
say(color.hidden("Hidden text"))
```

## RGB Colors

Create custom colors using RGB values (0-255):

```levy
# Foreground RGB
say(color.rgb(255, 100, 0, "Custom orange color"))
say(color.rgb(0, 255, 128))  # Returns code only

# Background RGB
say(color.bg_rgb(50, 100, 200, "Blue background"))
say(color.bg_rgb(255, 0, 255))  # Returns code only
```

## Combining Styles

You can combine multiple color functions:

```levy
say(color.bold(color.red("Bold red text")))
say(color.underline(color.green("Underlined green")))
say(color.bg_blue(color.yellow("Yellow on blue")))
say(color.bold(color.italic(color.cyan("Bold italic cyan"))))
```

## Utility Functions

### reset()
Reset all colors and styles to default:

```levy
say(color.red("Red") + color.reset() + " Normal")
```

### colorize(text, color_name)
Apply a named color to text:

```levy
say(color.colorize("Hello", "red"))
say(color.colorize("World", "green"))
```

Supported color names: `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`, `black`

## Color Constants

Direct access to ANSI color codes:

```levy
say(color.RED + "Red text" + color.RESET)
say(color.GREEN + "Green text" + color.RESET)
say(color.BLUE + "Blue text" + color.RESET)
```

Available constants:
- `color.RESET`
- `color.RED`, `color.GREEN`, `color.YELLOW`, `color.BLUE`
- `color.MAGENTA`, `color.CYAN`, `color.WHITE`, `color.BLACK`

## Examples

### Rainbow Text
```levy
import color

say(color.red("R") + 
    color.yellow("a") + 
    color.green("i") + 
    color.cyan("n") + 
    color.blue("b") + 
    color.magenta("o") + 
    color.red("w"))
```

### Status Messages
```levy
import color

say(color.green("✓") + " Success!")
say(color.yellow("⚠") + " Warning!")
say(color.red("✗") + " Error!")
```

### Colored Game UI (Snake Example)
```levy
import color

# Green snake body
snake_body <- color.green("█")
# Bright green head
snake_head <- color.bright_green("■")
# Red food
food <- color.red("●")
# Cyan borders
border <- color.cyan("╔════╗")

say(border)
say(color.cyan("║") + snake_head + snake_body + food + color.cyan("║"))
say(color.cyan("╚════╝"))
```

### Colored Progress Bar
```levy
import color

act show_progress(percent) {
    filled <- int(percent / 5)
    empty <- 20 - filled
    
    bar <- color.green("█" * filled) + color.dim("░" * empty)
    say("[" + bar + "] " + color.bright_cyan(str(percent) + "%"))
}

show_progress(75)  # [███████████████░░░░░] 75%
```

### Colored Logs
```levy
import color

act log_info(msg) {
    say(color.blue("[INFO]") + " " + msg)
}

act log_warning(msg) {
    say(color.yellow("[WARN]") + " " + msg)
}

act log_error(msg) {
    say(color.red("[ERROR]") + " " + msg)
}

log_info("Application started")
log_warning("Low memory")
log_error("Connection failed")
```

## Platform Support

- **Linux/macOS**: Full ANSI color support in most terminals
- **Windows**: Works in Windows Terminal, PowerShell 7+, and terminals with ANSI support
- **Classic CMD**: May require Windows 10+ for proper color display

## Notes

- Colors automatically reset at the end of each function call when text is provided
- For manual control, use the no-argument form and add `color.reset()` manually
- RGB colors require terminal with 24-bit color support (most modern terminals)
- Some styles (like `blink`, `italic`) may not work in all terminals

## API Reference

### Color Functions
| Function | Description | Example |
|----------|-------------|---------|
| `red(text?)` | Red foreground | `color.red("Error")` |
| `green(text?)` | Green foreground | `color.green("Success")` |
| `yellow(text?)` | Yellow foreground | `color.yellow("Warning")` |
| `blue(text?)` | Blue foreground | `color.blue("Info")` |
| `magenta(text?)` | Magenta foreground | `color.magenta("Debug")` |
| `cyan(text?)` | Cyan foreground | `color.cyan("Note")` |
| `white(text?)` | White foreground | `color.white("Text")` |
| `black(text?)` | Black foreground | `color.black("Text")` |

### Style Functions
| Function | Description | Example |
|----------|-------------|---------|
| `bold(text?)` | Bold text | `color.bold("Important")` |
| `dim(text?)` | Dimmed text | `color.dim("Subtle")` |
| `italic(text?)` | Italic text | `color.italic("Emphasis")` |
| `underline(text?)` | Underlined text | `color.underline("Link")` |
| `blink(text?)` | Blinking text | `color.blink("Alert")` |
| `reverse(text?)` | Reversed colors | `color.reverse("Inverted")` |
| `hidden(text?)` | Hidden text | `color.hidden("Secret")` |

### RGB Functions
| Function | Parameters | Description |
|----------|------------|-------------|
| `rgb(r, g, b, text?)` | r,g,b: 0-255, text: optional | Custom foreground color |
| `bg_rgb(r, g, b, text?)` | r,g,b: 0-255, text: optional | Custom background color |

### Utility Functions
| Function | Parameters | Description |
|----------|------------|-------------|
| `reset()` | None | Reset all styles |
| `colorize(text, color)` | text: string, color: name | Apply named color |

---

**Built with ❤️ in Levython**