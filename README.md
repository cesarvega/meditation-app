# 🧘‍♀️ Meditation App

A beautiful iOS meditation app built with SwiftUI, featuring an advanced audio player, background music, and comprehensive favorites management.

## ✨ Features

### 🎯 Meditation Categories
- **Sleep** - Peaceful sessions for better rest
- **Stress Relief** - Calm your mind and body  
- **Anxiety** - Find peace in challenging moments
- **Focus** - Enhance concentration and clarity
- **Gratitude** - Cultivate appreciation and joy
- **Favorites** - Quick access to your preferred meditations

### 🎵 Advanced Audio Player
- **Playback Controls**: Play/Pause, 15-second skip forward/backward
- **Variable Speed**: Adjust playback rate from 0.5x to 2.0x
- **Track Navigation**: Previous/Next meditation in category
- **Progress Tracking**: Visual timeline with seek functionality

### 🎼 Background Music System
- **5 Ambient Tracks**: Dream of Light, Nature Sounds, Rain Drops, Ocean Waves, Forest Ambience
- **Smart Navigation**: Previous/Next buttons appear when multiple tracks available
- **Seamless Switching**: Preserves playback state during track changes
- **Volume Control**: Adjustable background audio levels

### ❤️ Favorites Management
- **Easy Bookmarking**: Tap heart icon to add/remove favorites
- **Swipe to Delete**: iOS-native swipe left gesture to remove favorites
- **Persistent Storage**: Favorites saved across app launches
- **Clear All Option**: Bulk remove all favorites
- **Empty State**: Helpful instructions when no favorites exist

### 🌍 Bilingual Support
- **Languages**: Complete English and Spanish translations
- **Dynamic Switching**: Change language from main screen
- **Live Updates**: UI instantly updates on language change
- **Cultural Adaptation**: Content adapted for different audiences

### 🎨 Beautiful Design
- **Gradient Cards**: Each category has unique color schemes
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Background Images**: Immersive visual experience
- **Responsive Layout**: Works on all iPhone screen sizes
- **Dark Theme**: Optimized for relaxation and focus

## 🛠️ Technical Implementation

### Architecture
- **SwiftUI**: Declarative UI framework
- **MVVM Pattern**: Clear separation of concerns
- **ObservableObject**: Reactive state management
- **Combine Framework**: Data flow and binding

### Audio System
- **AVFoundation**: Professional audio playback
- **Multiple Fallbacks**: Robust file loading system
- **Background Audio**: Concurrent meditation and ambient sound
- **Rate Control**: Variable playback speed support

### Data Persistence
- **UserDefaults**: Lightweight favorites storage
- **FavoritesManager**: Centralized favorites logic
- **Language Settings**: Persistent language preference

### UI Components
- **NavigationStack**: Modern navigation system
- **List with SwipeActions**: Native iOS interaction patterns
- **ScrollView**: Smooth content browsing
- **Toolbar Customization**: Transparent navigation bars

## 📱 App Structure

```
Meditation/
├── MeditationApp.swift          # App entry point
├── ContentView.swift            # Main category grid
├── AudioPlayerManager.swift     # Audio playback logic
├── AudioPlayerView.swift        # Audio player interface  
├── CategoryDetailView.swift     # Meditation list per category
├── Category.swift              # Category model and types
├── CategoryCard.swift          # Category grid cards
├── Meditation.swift            # Meditation model
├── MeditationCard.swift        # Individual meditation cards
├── FavoritesManager.swift      # Favorites persistence
├── LanguageManager.swift       # Localization system
├── LanguagePickerView.swift    # Language selection UI
└── Assets.xcassets/           # Images and app icons
```

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/cesarvega/meditation-app.git
   cd meditation-app
   ```

2. **Open in Xcode**
   ```bash
   open Meditation.xcodeproj
   ```

3. **Add Audio Files** (Optional)
   - Create `audio/meditations/[category]/` folders in your project
   - Add MP3 files for each meditation
   - Ensure files are added to the Xcode target

4. **Run the App**
   - Select your target device/simulator
   - Press ⌘+R to build and run

## 🎵 Audio File Structure

For full functionality, organize audio files as follows:

```
audio/
├── background-sound/
│   ├── Dream of Light.mp3
│   ├── Nature Sounds.mp3
│   ├── Rain Drops.mp3
│   ├── Ocean Waves.mp3
│   └── Forest Ambience.mp3
└── meditations/
    ├── sleep/
    ├── stress-relief/
    ├── anxiety/
    ├── focus/
    └── gratitude/
```

## 🎯 Key Features Showcase

### Consolidated Audio Controls
All main playback controls are elegantly arranged on a single line:
`Previous Track | 15s Back | Play/Pause | 15s Forward | Next Track`

### Smart Background Track Navigation  
Navigation buttons automatically appear when multiple background tracks are available, maintaining clean UI when not needed.

### iOS-Native Swipe Gestures
Favorites use proper List-based swipe actions for authentic iOS interaction patterns, complete with animation and haptic feedback.

### Bilingual Excellence
Seamless language switching affects all UI elements instantly, including dynamic content like meditation descriptions and category names.

## 📸 Screenshots

![Meditation Categories](https://via.placeholder.com/300x600/667ff0/ffffff?text=Categories+Grid)
![Audio Player](https://via.placeholder.com/300x600/667ff0/ffffff?text=Audio+Player)
![Favorites Management](https://via.placeholder.com/300x600/667ff0/ffffff?text=Swipe+to+Delete)

## 🤝 Contributing

Contributions are welcome! Here are ways to contribute:

1. **Add New Meditations**: Expand categories with additional content
2. **Improve Audio System**: Enhance playback features or add new audio formats
3. **UI Enhancements**: Improve animations, add new themes, or optimize layouts
4. **Localization**: Add support for additional languages
5. **Accessibility**: Enhance VoiceOver support and accessibility features

## 📄 License

This project is available for educational and personal use. See individual file headers for specific licensing information.

## 👨‍💻 Author

**Cesar Vega**
- Email: cesarvega.col@gmail.com
- GitHub: [@cesarvega](https://github.com/cesarvega)

---

*Built with ❤️ using SwiftUI and modern iOS development practices*