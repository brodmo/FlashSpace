#!/bin/bash

# Script to remove deleted file references from Xcode project
# Run this from the FlashSpace directory

set -e

PROJECT_FILE="FlashSpace.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "Error: $PROJECT_FILE not found"
    echo "Make sure you run this from the FlashSpace directory"
    exit 1
fi

echo "Backing up project file..."
cp "$PROJECT_FILE" "$PROJECT_FILE.backup"

echo "Removing references to deleted files..."

# List of deleted files (from error message)
DELETED_FILES=(
    "YAMLCoding.swift"
    "WorkspaceTransitionManager.swift"
    "WorkspaceSettingsViewModel.swift"
    "WorkspaceScreenshotManager.swift"
    "WorkspaceCommands.swift"
    "UpdateWorkspaceRequest.swift"
    "Toast.swift"
    "System.swift"
    "SwipeManager.swift"
    "SpaceControlWindow.swift"
    "SpaceControlViewModel.swift"
    "SpaceControlView.swift"
    "SpaceControlSettingsView.swift"
    "SpaceControlSettings.swift"
    "SpaceControlCommands.swift"
    "SpaceControl.swift"
    "SocketDataSerialization.swift"
    "ProfilesSettingsViewModel.swift"
    "ProfilesSettingsView.swift"
    "ProfilesRepository.swift"
    "ProfileCommands.swift"
    "Profile.swift"
    "PipBrowser.swift"
    "PipApp.swift"
    "PictureInPictureManager.swift"
    "PermissionsManager.swift"
    "NSScreen.swift"
    "NSRunningApplication+Properties.swift"
    "NSRunningApplication+PiP.swift"
    "NSRunningApplication+Actions.swift"
    "NSAccessibility+Attributes.swift"
    "MenuBarTitle.swift"
    "MenuBarSettingsView.swift"
    "MenuBarSettings.swift"
    "MacAppWithWorkspace.swift"
    "MacAppWithWindows.swift"
    "ListCommands.swift"
    "JSONCoding.swift"
    "IntegrationsSettingsView.swift"
    "IntegrationsSettings.swift"
    "Integrations.swift"
    "GetCommands.swift"
    "GesturesSettingsView.swift"
    "GesturesSettings.swift"
    "GestureAction.swift"
    "FocusedWindowTracker.swift"
    "FocusCommands.swift"
    "FloatingAppsSettingsViewModel.swift"
    "FloatingAppsSettingsView.swift"
    "FloatingAppsSettings.swift"
    "FloatingAppsHotKeys.swift"
    "FlashSpaceMenuBar.swift"
    "CreateWorkspaceRequest.swift"
    "ConfigFormat.swift"
    "CommandResponse.swift"
    "CommandRequest.swift"
    "CommandExecutor.swift"
    "DisplayManager.swift"
    "CLISettingsView.swift"
    "CLIServer.swift"
    "CLI.swift"
    "CGRect.swift"
    "BufferWrapper.swift"
    "AppCommands.swift"
    "AXUIElement+Properties.swift"
    "AXUIElement+PiP.swift"
    "AXUIElement+GetSet.swift"
    "AXUIElement+CoreGraphics.swift"
    "AXUIElement+Actions.swift"
)

# Create a temporary file
TEMP_FILE=$(mktemp)

# For each deleted file, we need to:
# 1. Remove the PBXFileReference entry
# 2. Remove the PBXBuildFile entry
# 3. Remove from PBXSourcesBuildPhase

# This is complex because we need to track UUIDs and remove multiple related entries
# A simpler approach: use Ruby (Xcode uses xcodeproj gem)

cat > /tmp/clean_project.rb << 'EOF'
#!/usr/bin/env ruby

require 'xcodeproj'

project_path = ARGV[0]
deleted_files = ARGV[1..-1]

project = Xcodeproj::Project.open(project_path)

deleted_files.each do |filename|
  # Find and remove file references
  project.files.each do |file_ref|
    if file_ref.path && file_ref.path.end_with?(filename)
      puts "Removing reference to: #{file_ref.path}"
      file_ref.remove_from_project
    end
  end
end

project.save

puts "Project cleaned successfully!"
EOF

chmod +x /tmp/clean_project.rb

# Check if Ruby xcodeproj gem is available
if command -v gem &> /dev/null && gem list xcodeproj -i &> /dev/null; then
    echo "Using Ruby xcodeproj gem to clean project..."
    ruby /tmp/clean_project.rb "FlashSpace.xcodeproj" "${DELETED_FILES[@]}"
else
    echo ""
    echo "Ruby xcodeproj gem not found. Please do one of the following:"
    echo ""
    echo "Option 1: Install xcodeproj gem and run this script again"
    echo "  gem install xcodeproj"
    echo "  ./clean-xcode-references.sh"
    echo ""
    echo "Option 2: Clean manually in Xcode"
    echo "  1. Open FlashSpace.xcodeproj in Xcode"
    echo "  2. In Project Navigator, look for red (missing) files"
    echo "  3. Select all red files and delete (Remove Reference only)"
    echo ""
    echo "Option 3: Regenerate the Xcode project (if using SPM)"
    echo "  rm -rf FlashSpace.xcodeproj"
    echo "  xcodegen generate  # if using XcodeGen"
    echo ""
    echo "A backup was created at: $PROJECT_FILE.backup"
    exit 1
fi

echo "Done! Backup saved at: $PROJECT_FILE.backup"
