//
//  AudioPlayerView.swift
//  Meditation
//
//  Created by Cesar Vega on 10/2/25.
//

import SwiftUI

struct AudioPlayerView: View {
    let meditation: Meditation
    let categoryColor: Color
    let languageManager: LanguageManager
    
    @StateObject private var audioManager = AudioPlayerManager()
    @State private var playbackSpeed: Double = 1.0
    @State private var isHovering: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    // Pink accent color similar to the female character's shirt
    private let accentColor = Color(red: 0.95, green: 0.75, blue: 0.85) // Soft pink/rose
    
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
                        // Bookmark action
                    }) {
                        Image(systemName: "bookmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Main content area
                VStack(spacing: 20) {
                    // Female meditation character
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
                        
                        // Female character image
                        Image("female")
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
                    // Main playback controls
                    HStack(spacing: 40) {
                        // Previous button
                        Button(action: {
                            audioManager.skipBackward(seconds: 15)
                        }) {
                            Image(systemName: "gobackward.15")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.8))
                                .frame(width: 50, height: 50)
                                .background(Color.white.opacity(0.1))
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
                        
                        // Next button
                        Button(action: {
                            audioManager.skipForward(seconds: 15)
                        }) {
                            Image(systemName: "goforward.15")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.8))
                                .frame(width: 50, height: 50)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    
                    // Playback speed control
                    VStack(spacing: 6) {
                        Text(languageManager.currentLanguage == .spanish ? "Velocidad" : "Speed")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        HStack(spacing: 12) {
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
                        .padding(.horizontal, 30)
                        
                        Text(String(format: "%.1f×", playbackSpeed))
                            .font(.subheadline)
                            .foregroundColor(accentColor)
                    }
                    .padding(.vertical, 8)
                    
                    // Background music toggle
                    Button(action: {
                        audioManager.toggleBackgroundAudio()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: audioManager.isBackgroundPlaying ? "music.note.list" : "music.note")
                                .font(.callout)
                                .foregroundColor(.white)
                            
                            Text(languageManager.currentLanguage == .spanish ? "Música de Fondo" : "Background Music")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(width: 200, height: 40)
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
                titleEN: "Peaceful Drift",
                titleES: "Deriva Pacífica",
                descriptionEN: "A calming meditation for sleep",
                descriptionES: "Una meditación calmante para dormir",
                imageName: "audio-art-1",
                audioFileEN: "peaceful-drift-en.mp3",
                audioFileES: "peaceful-drift-es.mp3",
                category: .sleep
            ),
            categoryColor: .blue,
            languageManager: LanguageManager()
        )
    }
}
#endif