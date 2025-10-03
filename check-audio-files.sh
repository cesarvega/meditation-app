#!/bin/bash

# Script to verify audio files are in the correct location
# Run this from the Meditation project root directory

echo "🔍 Checking audio files in project..."
echo ""

# Check if audio directory exists
if [ ! -d "Meditation/audio/meditations" ]; then
    echo "❌ Error: Meditation/audio/meditations directory not found"
    echo "   Current directory: $(pwd)"
    exit 1
fi

echo "📁 Current audio files in project:"
echo ""

# Find all mp3 files
find Meditation/audio/meditations -name "*.mp3" -type f | while read file; do
    echo "✅ $file"
done

echo ""
echo "📋 Expected file structure:"
echo ""
echo "For Sleep meditations (in Meditation/audio/meditations/sleep/):"
echo "  - night-ocean-waves-en.mp3"
echo "  - night-ocean-waves-es.mp3"
echo "  (or use placeholder audio files)"
echo ""
echo "For Stress Relief meditations (in Meditation/audio/meditations/stress-relief/):"
echo "  ✅ mind-body-eng.mp3"
echo "  ✅ mind-body-esp.mp3"
echo ""
echo "⚠️  IMPORTANT: After adding files to the folder, you MUST:"
echo "   1. Open Xcode"
echo "   2. Select the .mp3 file in the project navigator"
echo "   3. In the File Inspector (right panel), check 'Meditation' under Target Membership"
echo "   4. Clean build folder (Shift+Cmd+K)"
echo "   5. Build and run"
echo ""
