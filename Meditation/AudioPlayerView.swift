//
//  AudioPlayerView.swift
//  Meditation
//
//  Created by Cesar Vega on 10/2/25.
//

import SwiftUI

struct AudioPlayerView: View {
    @State var meditation: Meditation
    let categoryColor: Color
    let languageManager: LanguageManager
    let themeManager: ThemeManager
    let favoritesManager: FavoritesManager
    
    @StateObject private var audioManager = AudioPlayerManager()
    @State private var playbackSpeed: Double = 1.0
    @State private var isHovering: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    // Track meditations in the same category
    private var categoryMeditations: [Meditation] {
        if meditation.category == .favorites {
            return Meditation.favoritesMeditations(favoritesManager: favoritesManager)
        } else {
            return Meditation.meditations(for: meditation.category)
        }
    }
    
    private var currentIndex: Int {
        categoryMeditations.firstIndex { $0.uniqueId == meditation.uniqueId } ?? 0
    }
    
    private var hasNextTrack: Bool {
        currentIndex < categoryMeditations.count - 1
    }
    
    private var hasPreviousTrack: Bool {
        currentIndex > 0
    }
    
    // Track navigation methods
    private func playPreviousTrack() {
        if hasPreviousTrack {
            let previousMeditation = categoryMeditations[currentIndex - 1]
            meditation = previousMeditation
            loadCurrentTrack()
        }
    }
    
    private func playNextTrack() {
        if hasNextTrack {
            let nextMeditation = categoryMeditations[currentIndex + 1]
            meditation = nextMeditation
            loadCurrentTrack()
        }
    }
    
    private func loadCurrentTrack() {
        let audioFileName = languageManager.currentLanguage == .spanish ? meditation.audioFileES : meditation.audioFileEN
        let categoryFolder = meditation.category.rawValue
        audioManager.loadAudio(fileName: audioFileName, categoryFolder: categoryFolder)
        
        // Start playing the new track automatically
        if !audioManager.isPlaying {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                audioManager.togglePlayPause()
            }
        }
    }
    
    // Use theme accent color
    private var accentColor: Color {
        themeManager.currentTheme.accentColor
    }
    
    var progress: Double {
        audioManager.duration > 0 ? audioManager.currentTime / audioManager.duration : 0
    }
    
    var timeRemaining: String {
        let remaining = audioManager.duration - audioManager.currentTime
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var currentTimeString: String {
        let minutes = Int(audioManager.currentTime) / 60
        let seconds = Int(audioManager.currentTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            // Background image
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea(.all)
            
            VStack {
                // Top navigation bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                    
                    Text(languageManager.currentLanguage == .spanish ? "Reproductor de Audio" : "Audio Player")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        favoritesManager.toggleFavorite(meditation.uniqueId)
                    }) {
                        Image(systemName: favoritesManager.isFavorite(meditation.uniqueId) ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(favoritesManager.isFavorite(meditation.uniqueId) ? accentColor : .white)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Main content area
                VStack(spacing: 20) {
                    // Meditation character (changes based on theme)
                    ZStack {
                        // Ambient glow effect
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        accentColor.opacity(0.3),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 40,
                                    endRadius: 120
                                )
                            )
                            .frame(width: 240, height: 240)
                            .blur(radius: 20)
                        
                        // Character image (male for light blue theme, female for pink theme)
                        Image(themeManager.currentTheme == .lightBlue ? "male" : "female")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 160, height: 160)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [accentColor, accentColor.opacity(0.5)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                            )
                            .shadow(color: accentColor.opacity(0.3), radius: 15, x: 0, y: 8)
                    }
                    .offset(y: isHovering ? -10 : 0)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isHovering
                    )
                    .onAppear {
                        isHovering = true
                    }
                    
                    // Title and status
                    VStack(spacing: 8) {
                        Text(meditation.title(languageManager: languageManager))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 30)
                        
                        Text(audioManager.isPlaying ? 
                             (languageManager.currentLanguage == .spanish ? "En Progreso" : "In Progress") :
                             (languageManager.currentLanguage == .spanish ? "Pausado" : "Paused")
                        )
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        // Track counter
                        if categoryMeditations.count > 1 {
                            Text("\(currentIndex + 1) \(languageManager.currentLanguage == .spanish ? "de" : "of") \(categoryMeditations.count)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        // Show error if any
                        if let error = audioManager.error {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(accentColor)
                                .padding(.horizontal)
                        }
                    }
                }
                
                // Audio progress and wave visualization
                VStack(spacing: 15) {
                    // Progress indicator
                    VStack(spacing: 6) {
                        HStack {
                            Text(currentTimeString)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Spacer()
                            
                            Text(timeRemaining)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 4)
                                    .cornerRadius(2)
                                
                                Rectangle()
                                    .fill(accentColor)
                                    .frame(width: geometry.size.width * progress, height: 4)
                                    .cornerRadius(2)
                            }
                        }
                        .frame(height: 4)
                    }
                    
                    // Wave visualization
                    AudioWaveView(isPlaying: audioManager.isPlaying, color: accentColor)
                        .frame(height: 40)
                }
                .padding(.horizontal, 40)
                
                // Control buttons
                VStack(spacing: 20) {
                    // All main playback controls in one line
                    HStack(spacing: 15) {
                        // Previous track button
                        Button(action: {
                            playPreviousTrack()
                        }) {
                            Image(systemName: "backward.fill")
                                .font(.title3)
                                .foregroundColor(hasPreviousTrack ? .white.opacity(0.8) : .white.opacity(0.4))
                                .frame(width: 45, height: 45)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .disabled(!hasPreviousTrack)
                        
                        // Skip backward 15 seconds
                        Button(action: {
                            audioManager.skipBackward(seconds: 15)
                        }) {
                            Image(systemName: "gobackward.15")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 45, height: 45)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Circle())
                        }
                        
                        // Play/Pause button
                        Button(action: {
                            audioManager.togglePlayPause()
                        }) {
                            Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 70, height: 70)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [accentColor, accentColor.opacity(0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: accentColor.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        
                        // Skip forward 15 seconds
                        Button(action: {
                            audioManager.skipForward(seconds: 15)
                        }) {
                            Image(systemName: "goforward.15")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 45, height: 45)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Circle())
                        }
                        
                        // Next track button
                        Button(action: {
                            playNextTrack()
                        }) {
                            Image(systemName: "forward.fill")
                                .font(.title3)
                                .foregroundColor(hasNextTrack ? .white.opacity(0.8) : .white.opacity(0.4))
                                .frame(width: 45, height: 45)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .disabled(!hasNextTrack)
                    }
                    
                    // Speed control section
                    VStack(spacing: 10) {
                        // Speed control title
                        Text(languageManager.currentLanguage == .spanish ? "Velocidad" : "Speed")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        // Speed slider
                        VStack(spacing: 4) {
                            HStack(spacing: 8) {
                                Text("0.5×")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Slider(value: $playbackSpeed, in: 0.5...1.0, step: 0.1)
                                    .accentColor(accentColor)
                                    .onChange(of: playbackSpeed) { newValue in
                                        audioManager.setPlaybackRate(Float(newValue))
                                    }
                                
                                Text("1.0×")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Text(String(format: "%.1f×", playbackSpeed))
                                .font(.caption)
                                .foregroundColor(accentColor)
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.vertical, 8)
                    
                    // Background music section with navigation
                    HStack(spacing: 15) {
                        // Previous background track button (only show if multiple tracks available)
                        if audioManager.hasMultipleBackgroundTracks {
                            Button(action: {
                                audioManager.playPreviousBackgroundTrack()
                            }) {
                                Image(systemName: "backward.fill")
                                    .font(.title3)
                                    .foregroundColor(audioManager.hasPreviousBackground ? .white.opacity(0.8) : .white.opacity(0.4))
                                    .frame(width: 40, height: 40)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .disabled(!audioManager.hasPreviousBackground)
                        }
                        
                        // Background music toggle
                        Button(action: {
                            audioManager.toggleBackgroundAudio()
                        }) {
                            VStack(spacing: 4) {
                                HStack(spacing: 8) {
                                    Image(systemName: audioManager.isBackgroundPlaying ? "music.note.list" : "music.note")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                    
                                    Text(languageManager.currentLanguage == .spanish ? "Música de Fondo" : "Background Music")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                
                                // Show current background track name if multiple available
                                if audioManager.hasMultipleBackgroundTracks && !audioManager.currentBackgroundTrackName.isEmpty {
                                    Text(audioManager.displayBackgroundTrackName)
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.7))
                                        .lineLimit(1)
                                }
                            }
                            .frame(width: audioManager.hasMultipleBackgroundTracks ? 180 : 200, height: 40)
                            .background(
                                audioManager.isBackgroundPlaying ?
                                    LinearGradient(
                                        gradient: Gradient(colors: [accentColor, accentColor.opacity(0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) :
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.1)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                            )
                            .cornerRadius(20)
                            .shadow(color: audioManager.isBackgroundPlaying ? accentColor.opacity(0.3) : Color.clear, radius: 6, x: 0, y: 3)
                        }
                        
                        // Next background track button (only show if multiple tracks available)
                        if audioManager.hasMultipleBackgroundTracks {
                            Button(action: {
                                audioManager.playNextBackgroundTrack()
                            }) {
                                Image(systemName: "forward.fill")
                                    .font(.title3)
                                    .foregroundColor(audioManager.hasNextBackground ? .white.opacity(0.8) : .white.opacity(0.4))
                                    .frame(width: 40, height: 40)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .disabled(!audioManager.hasNextBackground)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Load the audio file based on current language and category
            let audioFileName = meditation.audioFile(languageManager: languageManager)
            let categoryFolder: String
            
            switch meditation.category {
            case .favorites: categoryFolder = "" // Favorites don't have their own audio folder
            case .sleep: categoryFolder = "sleep"
            case .stressRelief: categoryFolder = "stress-relief"
            case .anxiety: categoryFolder = "anxiety"
            case .focus: categoryFolder = "focus"
            case .gratitude: categoryFolder = "gratitude"
            }
            
            audioManager.loadAudio(fileName: audioFileName, categoryFolder: categoryFolder)
            
            // Load background audio
            audioManager.loadBackgroundAudio()
        }
        .onDisappear {
            // Stop audio when leaving the screen
            audioManager.stop()
        }
    }
}

// Audio Wave Visualization
struct AudioWaveView: View {
    let isPlaying: Bool
    let color: Color
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<50, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color.opacity(0.6))
                    .frame(width: 2, height: waveHeight(for: index))
                    .animation(
                        isPlaying ? 
                        Animation.easeInOut(duration: Double.random(in: 0.5...1.5)).repeatForever() :
                        .default,
                        value: isPlaying
                    )
            }
        }
        .onAppear {
            if isPlaying {
                withAnimation(Animation.linear(duration: 2).repeatForever()) {
                    animationOffset = 100
                }
            }
        }
    }
    
    private func waveHeight(for index: Int) -> CGFloat {
        let baseHeight: CGFloat = 4
        let maxHeight: CGFloat = 40
        
        if !isPlaying {
            return baseHeight
        }
        
        let wave = sin(Double(index) * 0.3 + Double(animationOffset) * 0.1) * 0.5 + 0.5
        return baseHeight + CGFloat(wave) * (maxHeight - baseHeight)
    }
}

// Schedule Modal View - Commented out for now
/*
struct ScheduleView: View {
    let languageManager: LanguageManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text(languageManager.currentLanguage == .spanish ? 
                     "Programar Meditación" : 
                     "Schedule Meditation")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                // Schedule options would go here
                Text(languageManager.currentLanguage == .spanish ? 
                     "Funcionalidad de programación próximamente..." : 
                     "Scheduling functionality coming soon...")
                    .foregroundColor(.secondary)
                    .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(languageManager.currentLanguage == .spanish ? "Cancelar" : "Cancel") {
                    dismiss()
                }
            )
        }
    }
}
*/

// Preview
#if DEBUG
struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayerView(
            meditation: Meditation(
                uniqueId: "peaceful-drift",
                titleEN: "Peaceful Drift",
                titleES: "Deriva Pacífica",
                descriptionEN: "A calming meditation for sleep",
                descriptionES: "Una meditación calmante para dormir",
                imageName: "audio-art-1",
                audioFileEN: "peaceful-drift-en.mp3",
                audioFileES: "peaceful-drift-es.mp3",
                category: .sleep,
                rating: 4.0
            ),
            categoryColor: .blue,
            languageManager: LanguageManager(),
            themeManager: ThemeManager(),
            favoritesManager: FavoritesManager()
        )
    }
}
#endif