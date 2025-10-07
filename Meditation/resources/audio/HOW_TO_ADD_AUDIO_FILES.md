# How to Add Audio Files to Xcode Project

## Quick Steps

1. **Place your MP3/WAV files** in the appropriate category folder:
   ```
   Meditation/audio/meditations/[category]/your-audio-file.{mp3|wav}
   ```

2. **Add to Xcode Project**:
   - Open Xcode
   - Right-click on the `audio/meditations/[category]` folder in Xcode
   - Select "Add Files to 'Meditation'..."
   - Select your audio files
   - ✅ **IMPORTANT**: Check "Copy items if needed"
   - ✅ **IMPORTANT**: Make sure "Add to targets: Meditation" is checked
   - Click "Add"

3. **Verify the file is added**:
   - Select the audio file in Xcode
   - Open the File Inspector (right panel)
   - Under "Target Membership", ensure "Meditation" is checked

## Current Audio Files

### Sleep Category ✅
- `peaceful-drift-en.mp3`
- `peaceful-drift-es.mp3`
- `night-ocean-waves-en.mp3`
- `night-ocean-waves-es.mp3`
- `release-the-day-en.mp3`
- `release-the-day-es.mp3`

### Stress Relief Category ✅
- `unwind-the-mind-en.mp3`
- `unwind-the-mind-es.mp3`
- `melting-the-pressure-en.mp3`
- `melting-the-pressure-es.mp3`
- `quiet-center-en.mp3`
- `quiet-center-es.mp3`

### Anxiety Category ✅
- `calm-in-the-storm-en.mp3`
- `calm-in-the-storm-es.mp3`
- `ground-and-breathe-en.mp3`
- `ground-and-breathe-es.mp3`
- `soft-heart-steady-mind-en.mp3`
- `soft-heart-steady-mind-es.mp3`

### Focus Category ✅
- `clear-the-fog-en.mp3`
- `clear-the-fog-es.mp3`

### Gratitude Category ✅ (shared)
- `grateful-heart-en.mp3` (usado por las tres meditaciones en inglés)
- `grateful-heart-es.mp3` (usado por las tres meditaciones en español)

### Meditation Music Category ✅
- `Celestial_Whispers.mp3`
- `Cosmic_Journey.mp3`
- `Ethereal_Waves.mp3`
- `Heavenly_Breeze.mp3`
- `Luminous_Dreams.mp3`
- `Peaceful_Cosmos.mp3`
- `Serene_Galaxy.mp3`
- `Starlight_Meditation.mp3`
- `Tranquil_Skies.mp3`

## Adding More Audio Files

La aplicación espera encontrar los siguientes nombres dentro de cada carpeta:

- **Sleep**: `peaceful-drift-en.mp3`, `peaceful-drift-es.mp3`, `night-ocean-waves-en.mp3`, `night-ocean-waves-es.mp3`, `release-the-day-en.mp3`, `release-the-day-es.mp3`
- **Stress Relief**: `unwind-the-mind-en.mp3`, `unwind-the-mind-es.mp3`, `melting-the-pressure-en.mp3`, `melting-the-pressure-es.mp3`, `quiet-center-en.mp3`, `quiet-center-es.mp3`
- **Anxiety**: `calm-in-the-storm-en.mp3`, `calm-in-the-storm-es.mp3`, `ground-and-breathe-en.mp3`, `ground-and-breathe-es.mp3`, `soft-heart-steady-mind-en.mp3`, `soft-heart-steady-mind-es.mp3`
- **Focus**: `clear-the-fog-en.mp3`, `clear-the-fog-es.mp3`
- **Gratitude**: `grateful-heart-en.mp3`, `grateful-heart-es.mp3` *(compartidos por las tres meditaciones)*
- **Meditation Music**: pistas en `resources/audio/background-sound` (mismos nombres que en la lista anterior)

Si añades grabaciones diferentes con otros nombres, actualiza las referencias en `Meditation.swift` para cada meditación correspondiente.

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
- Usa `.mp3` o `.wav` según tu mezcla final (el proyecto ya reproduce ambos)
- Avoid spaces and special characters
