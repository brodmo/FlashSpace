# ⚡ FlashCut

FlashCut is a lightweight, **stateless** macOS utility focused on keyboard shortcuts and app focus management.
It's a streamlined fork of [FlashSpace](https://github.com/wojciech-kulik/FlashSpace), reimagined around
simple app groups and a completely stateless architecture.

## 🎯 Design Goals

FlashCut was forked with these core principles:

1. **Stateless Architecture**: No tracking of "active workspace" or display assignments. App groups are simple collections - press a hotkey, focus an app in that group. That's it.

2. **App-Centric Design**: The fundamental unit is the **app**, not the workspace. When you cycle, the current app determines which group you're cycling within.

3. **Keyboard-First Simplicity**: Every operation is a keyboard shortcut. No complex UI, no window management, no hiding/showing logic.

4. **Minimal Complexity**: Remove features that add state tracking, display management, or debugging complexity.

## ✨ Features

- **App Groups**: Simple collections of apps, each with an optional activation hotkey
- **Stateless Activation**: Press a group hotkey → focus any running app in that group
- **Smart Cycling**: Press cycle hotkey → determine current app's group → cycle within that group
- **Focus Management**: Cycle through apps or windows within the current group
- **Auto-Launch**: Optionally launch apps when activating a group
- **Launch at Login**: Run in the background on macOS startup
- **Auto-Updates**: Built-in updater using Sparkle

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

## 💬 How It Works

### App Groups (Not Workspaces)

App groups are **stateless collections** of apps. Unlike traditional workspace managers:

- **No active state**: FlashCut doesn't track which group is "active"
- **No display assignments**: Groups aren't bound to screens or displays
- **No window hiding**: Activating a group simply focuses an app - other apps stay visible

### Usage Flow

1. **Create app groups** in Settings → App Groups
2. **Assign apps** to groups using hotkeys or the UI
3. **Set activation hotkeys** for each group (optional)
4. **Use keyboard shortcuts**:
   - Press group hotkey → focus any running app in that group
   - Press cycle hotkey → cycle through apps in the current app's group
   - Press assign hotkey → add focused app to a group

### Example

```
Group "Development": VSCode, Terminal, Safari
Group "Communication": Slack, Mail, Calendar

Workflow:
1. Focus VSCode (in Development group)
2. Press "Next App" → cycles to Terminal (same group)
3. Press "Communication Group" hotkey → focuses Slack
4. Press "Next App" → cycles to Mail (Communication group)
```

The current app determines the context - no state tracking needed.

## 🎯 Differences from FlashSpace

FlashCut removes:

- ❌ Active workspace tracking
- ❌ Display/screen management
- ❌ App hiding/showing logic
- ❌ Workspace transitions
- ❌ SpaceControl grid UI
- ❌ Profiles system
- ❌ Gesture support
- ❌ CLI interface
- ❌ Picture-in-Picture support
- ❌ Directional focus (left/right/up/down)
- ❌ Menu bar customization
- ❌ Integration system
- ❌ Empty workspace tracking

FlashCut keeps:

- ✅ App group activation via hotkeys
- ✅ App/window cycling within groups
- ✅ Stateless architecture (no active workspace)
- ✅ App assignment hotkeys
- ✅ Auto-launch apps on group activation
- ✅ Basic settings UI
- ✅ Launch at login
- ✅ Auto-updates (Sparkle)

## ⚙️ Configuration

Settings are stored in `~/.config/flashcut/settings.json`.

Key settings:

- **Center Cursor on App Activation**: Move cursor to center of focused app
- **Loop Groups**: When cycling past the last group, loop to first
- **Hotkeys**: Assign/unassign apps, cycle groups, focus next/previous app

## 🛠️ Development

This project uses XcodeGen to generate the Xcode project from `project.yml`.

```bash
# Regenerate project after changes
xcodegen generate

# Build and run in Xcode
open FlashCut.xcodeproj
```

### Architecture Notes

- **Stateless design**: `WorkspaceManager` has minimal state (just `lastActivatedWorkspace` for cycling)
- **No display tracking**: Removed `DisplayManager` dependency and all screen-based logic
- **App-centric**: Focus decisions based on current app, not workspace state
- **Simplified settings**: Removed 9+ state-tracking settings (displayMode, auto-switching, empty workspace tracking, etc.)

## 📝 License

See LICENSE file for details.

## 🙏 Credits

FlashCut is a fork of [FlashSpace](https://github.com/wojciech-kulik/FlashSpace) by Wojciech Kulik.

The fork was created to explore a simpler, stateless approach to app group management focused purely on keyboard-driven focus control.
