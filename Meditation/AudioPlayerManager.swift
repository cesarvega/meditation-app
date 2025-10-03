//
//  AudioPlayerManager.swift
//  Meditation
//
//  Created by Cesar Vega on 10/2/25.
//

import Foundation
import AVFoundation
import Combine

class AudioPlayerManager: NSObject, ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var error: String?
    @Published var isBackgroundPlaying: Bool = false
    
    private var audioPlayer: AVAudioPlayer?
    private var backgroundAudioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            self.error = "Failed to setup audio session: \(error.localizedDescription)"
        }
    }
    
    func loadAudio(fileName: String, categoryFolder: String) {
        // Remove .mp3 extension if present
        let fileNameWithoutExtension = fileName.replacingOccurrences(of: ".mp3", with: "")
        
        print("🔍 Searching for audio file:")
        print("   File name: \(fileName)")
        print("   Category folder: \(categoryFolder)")
        print("   Without extension: \(fileNameWithoutExtension)")
        
        // Try to load from bundle with subdirectory path
        // First try: audio/meditations/[category]/[filename]
        print("🔍 Try 1: audio/meditations/\(categoryFolder)/\(fileNameWithoutExtension).mp3")
        if let url = Bundle.main.url(forResource: fileNameWithoutExtension, withExtension: "mp3", subdirectory: "audio/meditations/\(categoryFolder)") {
            print("✅ Found at: \(url.path)")
            loadAudioFromURL(url)
            return
        }
        
        // Second try: Meditation/audio/meditations/[category]/[filename]
        print("🔍 Try 2: Meditation/audio/meditations/\(categoryFolder)/\(fileNameWithoutExtension).mp3")
        if let url = Bundle.main.url(forResource: fileNameWithoutExtension, withExtension: "mp3", subdirectory: "Meditation/audio/meditations/\(categoryFolder)") {
            print("✅ Found at: \(url.path)")
            loadAudioFromURL(url)
            return
        }
        
        // Third try: just the filename in the bundle root
        print("🔍 Try 3: Bundle root - \(fileNameWithoutExtension).mp3")
        if let url = Bundle.main.url(forResource: fileNameWithoutExtension, withExtension: "mp3") {
            print("✅ Found at: \(url.path)")
            loadAudioFromURL(url)
            return
        }
        
        // Fourth try: search in bundle for any matching file
        print("🔍 Try 4: Searching entire bundle...")
        if let url = findAudioFileInBundle(fileName: fileNameWithoutExtension) {
            loadAudioFromURL(url)
            return
        }
        
        // List all MP3 files in bundle for debugging
        listAllMP3FilesInBundle()
        
        self.error = "No audio loaded"
        print("❌ Audio file not found: \(fileName)")
        print("   Searched in: audio/meditations/\(categoryFolder)/")
        print("   Make sure the file is added to the Xcode project with target membership")
    }
    
    private func listAllMP3FilesInBundle() {
        print("📁 Listing ALL .mp3 files in bundle:")
        if let bundlePath = Bundle.main.resourcePath {
            let fileManager = FileManager.default
            if let enumerator = fileManager.enumerator(atPath: bundlePath) {
                var foundFiles: [String] = []
                while let file = enumerator.nextObject() as? String {
                    if file.hasSuffix(".mp3") {
                        foundFiles.append(file)
                    }
                }
                if foundFiles.isEmpty {
                    print("   ⚠️ No MP3 files found in bundle!")
                    print("   ⚠️ Files need to be added to Xcode project with target membership checked")
                } else {
                    print("   Found \(foundFiles.count) MP3 file(s):")
                    for file in foundFiles {
                        print("   - \(file)")
                    }
                }
            }
        }
    }
    
    private func findAudioFileInBundle(fileName: String) -> URL? {
        // Search for the file in the entire bundle
        if let bundlePath = Bundle.main.resourcePath {
            let fileManager = FileManager.default
            if let enumerator = fileManager.enumerator(atPath: bundlePath) {
                while let file = enumerator.nextObject() as? String {
                    if file.contains(fileName) && file.hasSuffix(".mp3") {
                        print("✅ Found audio file at: \(file)")
                        return URL(fileURLWithPath: bundlePath).appendingPathComponent(file)
                    }
                }
            }
        }
        return nil
    }
    
    private func loadAudioFromURL(_ url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            duration = audioPlayer?.duration ?? 0
            currentTime = 0
            error = nil
            print("✅ Audio loaded successfully: \(url.lastPathComponent)")
            print("   Duration: \(duration) seconds")
        } catch {
            self.error = "Failed to load audio: \(error.localizedDescription)"
            print("❌ Failed to load audio: \(error)")
        }
    }
    
    func play() {
        guard let player = audioPlayer else {
            error = "No audio loaded"
            return
        }
        
        player.play()
        isPlaying = true
        startTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        currentTime = 0
        isPlaying = false
        stopTimer()
        
        // Also stop background audio
        backgroundAudioPlayer?.stop()
        isBackgroundPlaying = false
    }
    
    func seek(to time: Double) {
        guard let player = audioPlayer else { return }
        player.currentTime = time
        currentTime = time
    }
    
    func skipForward(seconds: Double = 15) {
        guard let player = audioPlayer else { return }
        let newTime = min(player.currentTime + seconds, duration)
        seek(to: newTime)
    }
    
    func skipBackward(seconds: Double = 15) {
        guard let player = audioPlayer else { return }
        let newTime = max(player.currentTime - seconds, 0)
        seek(to: newTime)
    }
    
    func setPlaybackRate(_ rate: Float) {
        guard let player = audioPlayer else { return }
        player.enableRate = true
        player.rate = rate
        print("🎵 Playback rate set to: \(rate)x")
    }
    
    func loadBackgroundAudio() {
        // Load Dream of Light background audio
        if let url = Bundle.main.url(forResource: "Dream of Light", withExtension: "mp3", subdirectory: "audio/background-sound") {
            do {
                backgroundAudioPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundAudioPlayer?.numberOfLoops = -1 // Loop indefinitely
                backgroundAudioPlayer?.volume = 0.3 // Lower volume for background
                backgroundAudioPlayer?.prepareToPlay()
                print("✅ Background audio loaded: Dream of Light")
            } catch {
                print("❌ Failed to load background audio: \(error)")
            }
        } else {
            print("❌ Background audio file not found")
        }
    }
    
    func toggleBackgroundAudio() {
        guard let bgPlayer = backgroundAudioPlayer else {
            loadBackgroundAudio()
            guard backgroundAudioPlayer != nil else { return }
            toggleBackgroundAudio()
            return
        }
        
        if isBackgroundPlaying {
            bgPlayer.pause()
            isBackgroundPlaying = false
            print("⏸️ Background audio paused")
        } else {
            bgPlayer.play()
            isBackgroundPlaying = true
            print("▶️ Background audio playing")
        }
    }
    
    func setBackgroundVolume(_ volume: Float) {
        backgroundAudioPlayer?.volume = volume
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.currentTime = player.currentTime
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopTimer()
        audioPlayer?.stop()
        backgroundAudioPlayer?.stop()
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayerManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentTime = 0
        stopTimer()
        print("✅ Audio finished playing")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.error = "Audio decode error: \(error?.localizedDescription ?? "Unknown error")"
        isPlaying = false
        stopTimer()
        print("❌ Audio decode error: \(error?.localizedDescription ?? "Unknown")")
    }
}
