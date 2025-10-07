# Audio Files Guide

## Directory Structure

```
audio/
└── meditations/
    ├── sleep/
    │   ├── peaceful-drift-en.mp3
    │   ├── peaceful-drift-es.mp3
    │   ├── night-ocean-waves-en.mp3
    │   ├── night-ocean-waves-es.mp3
    │   ├── release-the-day-en.mp3
    │   └── release-the-day-es.mp3
    ├── stress-relief/
    │   ├── unwind-the-mind-en.mp3
    │   ├── unwind-the-mind-es.mp3
    │   ├── melting-the-pressure-en.mp3
    │   ├── melting-the-pressure-es.mp3
    │   ├── quiet-center-en.mp3
    │   └── quiet-center-es.mp3
    ├── anxiety/
    │   ├── calm-in-the-storm-en.mp3
    │   ├── calm-in-the-storm-es.mp3
    │   ├── ground-and-breathe-en.mp3
    │   ├── ground-and-breathe-es.mp3
    │   ├── soft-heart-steady-mind-en.mp3
    │   └── soft-heart-steady-mind-es.mp3
    ├── focus/
    │   ├── clear-the-fog-en.mp3
    │   └── clear-the-fog-es.mp3
    └── gratitude/
        ├── grateful-heart-en.mp3
        └── grateful-heart-es.mp3

```

> **Nota:** Actualmente, la categoría Focus utiliza un único par de archivos para su meditación disponible y Gratitude hace lo mismo. Cuando agregues más sesiones, conserva estos nombres o actualízalos en `Meditation.swift`.

## File Naming Convention

All audio files follow this pattern:
- **English**: `[meditation-name]-en.<ext>`
- **Spanish**: `[meditation-name]-es.<ext>`


## How It Works

1. **Language Detection**: The app automatically detects the user's selected language (English or Spanish)
2. **Audio Loading**: When a meditation is selected, the AudioPlayerManager loads the appropriate audio file based on:
   - The meditation's category folder
   - The user's current language setting
3. **Playback**: The AVAudioPlayer handles playback with full controls:
   - Play/Pause
   - Skip forward/backward 15 seconds
   - Progress tracking
   - Time display

## Adding New Audio Files

To add a new meditation:

1. Record both English and Spanish versions
2. Name the files following the convention above
3. Place them in the appropriate category folder
4. Update the `Meditation.swift` file to add the new meditation entry with:
   - Title (EN/ES)
   - Description (EN/ES)
   - Image name
   - Audio file names (EN/ES)
   - Category

## Technical Details

- **Format**: MP3 y WAV (Focus ES usa WAV por ahora)
- **Audio Session**: Configured for playback mode
- **Background Playback**: Supported (will continue playing in background)
- **Error Handling**: Displays error messages if audio files are missing
- **State Management**: Uses Combine framework for reactive updates

## Audio Player Features

✅ Language-aware audio selection
✅ Real-time progress tracking
✅ Skip forward/backward (15 seconds)
✅ Duration display
✅ Current time display
✅ Visual wave animation
✅ Play/Pause controls
✅ Auto-stop when leaving screen
