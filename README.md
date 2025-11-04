# ⚡ FlashCut

FlashCut is a lightweight macOS utility focused on keyboard shortcuts and focus management.
It's a streamlined fork of [FlashSpace](https://github.com/wojciech-kulik/FlashSpace), removing
heavy workspace management features in favor of simple app group switching and focus cycling.

## ✨ Features

- **App Groups**: Organize apps into groups with keyboard shortcuts for quick switching
- **Focus Cycling**: Cycle through apps within the current app group
- **Lightweight**: Minimal UI, runs in the background
- **Keyboard-First**: Control everything with hotkeys

## ⚙️ Installation

**Requirements:**

- macOS 14.0 or later

### Build From Source

```bash
# Install XcodeGen
brew install xcodegen

# Generate Xcode project
xcodegen generate

# Open in Xcode
open FlashCut.xcodeproj
```

## 💬 How to use

1. Create an app group
2. Assign apps to the group
3. Set a hotkey for the group
4. Use keyboard shortcuts to:
   - Switch to an app group
   - Cycle through apps in the current group

## 🎯 Differences from FlashSpace

FlashCut is a focused variant that removes:
- Complex workspace management
- App hiding/showing logic
- SpaceControl grid UI
- Profiles system
- Gestures
- CLI
- Picture-in-Picture support
- Menu bar customization
- Integrations

FlashCut keeps:
- App group activation via hotkeys
- App cycling within groups
- Basic settings UI
- Launch at login
- Auto-updates

## 🛠️ Development

This project uses XcodeGen to generate the Xcode project from `project.yml`.

```bash
# Regenerate project after changes
xcodegen generate
```

## 📝 License

See LICENSE file for details.

## 🙏 Credits

FlashCut is a fork of [FlashSpace](https://github.com/wojciech-kulik/FlashSpace) by Wojciech Kulik.
