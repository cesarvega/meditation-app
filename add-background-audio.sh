#!/bin/bash

# Script to add background audio files to Xcode project
# This script will add the audio files to the Xcode project so they can be used in the app

echo "🎵 Adding background audio files to Xcode project..."

# Navigate to project directory
cd "/Users/cesarvega/Movies/CUP-CUT/XCODE/Meditation"

# Check if we're in the right directory
if [ ! -f "Meditation.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: Could not find Meditation.xcodeproj/project.pbxproj"
    exit 1
fi

# List the audio files we want to add
echo "📁 Background audio files to add:"
ls -la "Meditation/resources/audio/background-sound/"*.mp3

# Open Xcode project to add files manually
echo ""
echo "🔧 To add these files to your Xcode project:"
echo "1. Open Meditation.xcodeproj in Xcode"
echo "2. Right-click on the 'resources/audio/background-sound' folder in the project navigator"
echo "3. Select 'Add Files to Meditation...'"
echo "4. Navigate to: Meditation/resources/audio/background-sound/"
echo "5. Select all .mp3 files and click 'Add'"
echo "6. Make sure 'Add to target: Meditation' is checked"
echo ""
echo "Or run this command to open Xcode:"
echo "open Meditation.xcodeproj"

# Alternatively, try to open Xcode automatically
read -p "Would you like to open Xcode now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Opening Xcode..."
    open Meditation.xcodeproj
fi

echo "✅ Script completed. Remember to add the audio files to the Xcode project!"