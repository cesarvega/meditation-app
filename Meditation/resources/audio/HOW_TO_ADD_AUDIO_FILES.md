# How to Add Audio Files to Xcode Project

## Quick Steps

1. **Place your MP3 files** in the appropriate category folder:
   ```
   Meditation/audio/meditations/[category]/your-audio-file.mp3
   ```

2. **Add to Xcode Project**:
   - Open Xcode
   - Right-click on the `audio/meditations/[category]` folder in Xcode
   - Select "Add Files to 'Meditation'..."
   - Select your MP3 files
   - ✅ **IMPORTANT**: Check "Copy items if needed"
   - ✅ **IMPORTANT**: Make sure "Add to targets: Meditation" is checked
   - Click "Add"

3. **Verify the file is added**:
   - Select the audio file in Xcode
   - Open the File Inspector (right panel)
   - Under "Target Membership", ensure "Meditation" is checked

## Current Audio Files

### Stress Relief Category ✅
- `mind-body-eng.mp3` - English version (READY)
- `mind-body-esp.mp3` - Spanish version (READY)

These files are currently used for ALL three stress-relief meditations:
- Unwind the Mind
- Melting the Pressure  
- Quiet Center

## Adding More Audio Files

For other categories, you need to add MP3 files with these names:

### Sleep Category
- `peaceful-drift-en.mp3` / `peaceful-drift-es.mp3`
- `night-ocean-waves-en.mp3` / `night-ocean-waves-es.mp3`
- `release-the-day-en.mp3` / `release-the-day-es.mp3`

### Anxiety Category
- `calm-in-the-storm-en.mp3` / `calm-in-the-storm-es.mp3`
- `ground-and-breathe-en.mp3` / `ground-and-breathe-es.mp3`
- `soft-heart-steady-mind-en.mp3` / `soft-heart-steady-mind-es.mp3`

### Focus Category
- `clear-the-fog-en.mp3` / `clear-the-fog-es.mp3`
- `laser-focus-en.mp3` / `laser-focus-es.mp3`
- `present-power-en.mp3` / `present-power-es.mp3`

### Gratitude Category
- `grateful-heart-en.mp3` / `grateful-heart-es.mp3`
- `seeds-of-joy-en.mp3` / `seeds-of-joy-es.mp3`
- `circle-of-thanks-en.mp3` / `circle-of-thanks-es.mp3`

## Troubleshooting

If audio doesn't play:

1. **Check Xcode Target Membership**:
   - Select the audio file in Xcode
   - Verify "Meditation" target is checked in File Inspector

2. **Clean Build Folder**:
   - In Xcode: Product → Clean Build Folder (Shift+Cmd+K)
   - Build and run again

3. **Check Console Logs**:
   - The app will print detailed error messages showing:
     - Where it's looking for the file
     - Whether the file was found
     - Any loading errors

## Temporary Solution

Until you have all audio files:
- Multiple meditations can share the same audio file
- The app will display an error message if a file is missing
- Users can still navigate the app; only audio playback will be affected

## File Naming Tips

- Use lowercase with hyphens: `my-meditation-en.mp3`
- Always include language suffix: `-en` or `-es`
- Keep the `.mp3` extension
- Avoid spaces and special characters
