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
    
    @State private var isPlaying = false
    @State private var currentTime: Double = 0
    @State private var totalTime: Double = 1800 // 30 minutes default
    @State private var showSchedule = false
    @Environment(\.dismiss) private var dismiss
    
    var progress: Double {
        totalTime > 0 ? currentTime / totalTime : 0
    }
    
    var timeRemaining: String {
        let remaining = totalTime - currentTime
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
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
                
                Spacer()
                
                // Main content area
                VStack(spacing: 40) {
                    // Female meditation character
                    ZStack {
                        // Ambient glow effect
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        categoryColor.opacity(0.3),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 50,
                                    endRadius: 150
                                )
                            )
                            .frame(width: 300, height: 300)
                            .blur(radius: 20)
                        
                        // Female character image
                        Image("female")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.3)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 4
                                    )
                            )
                            .shadow(color: categoryColor.opacity(0.3), radius: 20, x: 0, y: 10)
                    }
                    
                    // Title and status
                    VStack(spacing: 12) {
                        Text(meditation.title(languageManager: languageManager))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(isPlaying ? 
                             (languageManager.currentLanguage == .spanish ? "En Progreso" : "In Progress") :
                             (languageManager.currentLanguage == .spanish ? "Pausado" : "Paused")
                        )
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
                
                // Audio progress and wave visualization
                VStack(spacing: 30) {
                    // Progress indicator
                    VStack(spacing: 8) {
                        HStack {
                            Text("00:00")
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
                                    .fill(categoryColor)
                                    .frame(width: geometry.size.width * progress, height: 4)
                                    .cornerRadius(2)
                            }
                        }
                        .frame(height: 4)
                    }
                    
                    // Wave visualization
                    AudioWaveView(isPlaying: isPlaying, color: categoryColor)
                        .frame(height: 60)
                }
                .padding(.horizontal, 40)
                
                // Control buttons
                VStack(spacing: 30) {
                    // Main playback controls
                    HStack(spacing: 40) {
                        // Previous button
                        Button(action: {
                            // Previous track action
                        }) {
                            Image(systemName: "backward.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                                .frame(width: 60, height: 60)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        
                        // Play/Pause button
                        Button(action: {
                            isPlaying.toggle()
                        }) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: categoryColor.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        
                        // Next button
                        Button(action: {
                            // Next track action
                        }) {
                            Image(systemName: "forward.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                                .frame(width: 60, height: 60)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    
                    // Schedule button
                    Button(action: {
                        showSchedule = true
                    }) {
                        HStack {
                            Image(systemName: "triangle.fill")
                                .font(.caption)
                                .foregroundColor(categoryColor)
                                .rotationEffect(.degrees(90))
                            
                            Text(languageManager.currentLanguage == .spanish ? "Programar" : "Schedule")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Start progress simulation
            startProgressSimulation()
        }
        .sheet(isPresented: $showSchedule) {
            ScheduleView(languageManager: languageManager)
        }
    }
    
    private func startProgressSimulation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if isPlaying && currentTime < totalTime {
                currentTime += 1
            }
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

// Schedule Modal View
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
                imageName: "audio-art-1"
            ),
            categoryColor: .blue,
            languageManager: LanguageManager()
        )
    }
}
#endif