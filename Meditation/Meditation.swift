//
//  Meditation.swift
//  Meditation
//
//  Created by Cesar Vega on 10/2/25.
//

import Foundation

struct Meditation: Identifiable, Hashable {
    let uniqueId: String // For favorites persistence
    let titleEN: String
    let titleES: String
    let descriptionEN: String
    let descriptionES: String
    let imageName: String
    let audioFileEN: String
    let audioFileES: String
    let category: CategoryType
    let rating: Double // Rating out of 5 stars (e.g., 4.0, 4.5)
    let reviewsCount: Int

    init(
        uniqueId: String,
        titleEN: String,
        titleES: String,
        descriptionEN: String,
        descriptionES: String,
        imageName: String,
        audioFileEN: String,
        audioFileES: String,
        category: CategoryType,
        rating: Double = Meditation.randomRating(),
        reviewsCount: Int = Meditation.randomReviews()
    ) {
        self.uniqueId = uniqueId
        self.titleEN = titleEN
        self.titleES = titleES
        self.descriptionEN = descriptionEN
        self.descriptionES = descriptionES
        self.imageName = imageName
        self.audioFileEN = audioFileEN
        self.audioFileES = audioFileES
        self.category = category
        self.rating = rating
        self.reviewsCount = reviewsCount
    }
    
    var id: String { uniqueId }

    static func == (lhs: Meditation, rhs: Meditation) -> Bool {
        lhs.uniqueId == rhs.uniqueId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueId)
    }
    
    func title(languageManager: LanguageManager) -> String {
        languageManager.currentLanguage == .spanish ? titleES : titleEN
    }
    
    func description(languageManager: LanguageManager) -> String {
        languageManager.currentLanguage == .spanish ? descriptionES : descriptionEN
    }
    
    func audioFile(languageManager: LanguageManager) -> String {
        languageManager.currentLanguage == .spanish ? audioFileES : audioFileEN
    }
    
    func audioPath(languageManager: LanguageManager) -> String {
        let categoryFolder: String
        switch category {
        case .favorites: categoryFolder = "" // Favorites don't have their own folder
        case .sleep: categoryFolder = "sleep"
        case .stressRelief: categoryFolder = "stress-relief"
        case .anxiety: categoryFolder = "anxiety"
        case .focus: categoryFolder = "focus"
        case .gratitude: categoryFolder = "gratitude"
        case .meditationMusic: categoryFolder = "background-sound"
        }
        return "resources/audio/meditations/\(categoryFolder)/\(audioFile(languageManager: languageManager))"
    }

    func reviewsText(languageManager: LanguageManager) -> String {
        let value = Double(reviewsCount) / 1000
        let formatted: String
        if reviewsCount >= 10000 {
            formatted = String(format: "%.0fK", value)
        } else {
            formatted = String(format: "%.1fK", value)
        }
        return languageManager.currentLanguage == .spanish ? "\(formatted) reseñas" : "\(formatted) reviews"
    }

    private static func randomRating() -> Double {
        return (Double.random(in: 4.0...5.0) * 2).rounded() / 2
    }

    private static func randomReviews() -> Int {
        return Int.random(in: 1_200...65_000)
    }
    
    static func meditations(for category: CategoryType) -> [Meditation] {
        switch category {
        case .favorites:
            return [] // Favorites are handled separately
        case .sleep:
            return [
                Meditation(
                    uniqueId: "peaceful-drift",
                    titleEN: "Peaceful Drift",
                    titleES: "Deriva Pacífica",
                    descriptionEN: "Gently guide your mind and body into deep rest with calming breath and soft visualization.",
                    descriptionES: "Guía suavemente tu mente y cuerpo hacia el descanso profundo con respiración calmante.",
                    imageName: "audio-art-1",
                    audioFileEN: "peaceful-drift-en.mp3",
                    audioFileES: "peaceful-drift-es.mp3",
                    category: .sleep,
                    rating: 4.5
                ),
                Meditation(
                    uniqueId: "night-ocean-waves",
                    titleEN: "Night Ocean Waves",
                    titleES: "Olas del Océano Nocturno",
                    descriptionEN: "A soothing meditation using imagery of the sea to release tension and invite sleep.",
                    descriptionES: "Una meditación relajante usando imágenes del mar para liberar tensión e invitar al sueño.",
                    imageName: "audio-art-14",
                    audioFileEN: "night-ocean-waves-en.mp3",
                    audioFileES: "night-ocean-waves-es.mp3",
                    category: .sleep,
                    rating: 4.0
                ),
                Meditation(
                    uniqueId: "release-the-day",
                    titleEN: "Release the Day",
                    titleES: "Libera el Día",
                    descriptionEN: "Let go of thoughts, worries, and busyness as you prepare for a restorative night's rest.",
                    descriptionES: "Deja ir pensamientos y preocupaciones mientras te preparas para un descanso reparador.",
                    imageName: "audio-art-3",
                    audioFileEN: "release-the-day-en.mp3",
                    audioFileES: "release-the-day-es.mp3",
                    category: .sleep,
                    rating: 4.8
                )
            ]
            
        case .stressRelief:
            return [
                Meditation(
                    uniqueId: "unwind-the-mind",
                    titleEN: "Unwind the Mind",
                    titleES: "Relaja la Mente",
                    descriptionEN: "Ease mental tension with gentle breathing and body relaxation.",
                    descriptionES: "Alivia la tensión mental con respiración suave y relajación corporal.",
                    imageName: "audio-art-4",
                    audioFileEN: "unwind-the-mind-en.mp3",
                    audioFileES: "unwind-the-mind-es.mp3",
                    category: .stressRelief,
                    rating: 4.2
                ),
                Meditation(
                    uniqueId: "melting-the-pressure",
                    titleEN: "Melting the Pressure",
                    titleES: "Derritiendo la Presión",
                    descriptionEN: "A calming practice to soften stress, letting it dissolve from head to toe.",
                    descriptionES: "Una práctica calmante para suavizar el estrés, dejándolo disolverse de pies a cabeza.",
                    imageName: "audio-art-5",
                    audioFileEN: "melting-the-pressure-en.mp3",
                    audioFileES: "melting-the-pressure-es.mp3",
                    category: .stressRelief,
                    rating: 4.6
                ),
                Meditation(
                    uniqueId: "quiet-center",
                    titleEN: "Quiet Center",
                    titleES: "Centro Tranquilo",
                    descriptionEN: "Find your inner stillness by focusing on breath and grounding awareness.",
                    descriptionES: "Encuentra tu quietud interior enfocándote en la respiración y la conciencia.",
                    imageName: "audio-art-6",
                    audioFileEN: "quiet-center-en.mp3",
                    audioFileES: "quiet-center-es.mp3",
                    category: .stressRelief,
                    rating: 4.3
                )
            ]
            
        case .anxiety:
            return [
                Meditation(
                    uniqueId: "calm-in-the-storm",
                    titleEN: "Calm in the Storm",
                    titleES: "Calma en la Tormenta",
                    descriptionEN: "Learn to anchor yourself in the present when anxiety feels overwhelming.",
                    descriptionES: "Aprende a anclarte en el presente cuando la ansiedad se siente abrumadora.",
                    imageName: "audio-art-7",
                    audioFileEN: "calm-in-the-storm-en.mp3",
                    audioFileES: "calm-in-the-storm-es.mp3",
                    category: .anxiety,
                    rating: 4.7
                ),
                Meditation(
                    uniqueId: "ground-and-breathe",
                    titleEN: "Ground & Breathe",
                    titleES: "Anclar y Respirar",
                    descriptionEN: "A simple practice to steady the mind and reconnect to safety through the breath.",
                    descriptionES: "Una práctica simple para estabilizar la mente y reconectar con la seguridad.",
                    imageName: "audio-art-8",
                    audioFileEN: "ground-and-breathe-en.mp3",
                    audioFileES: "ground-and-breathe-es.mp3",
                    category: .anxiety,
                    rating: 4.4
                ),
                Meditation(
                    uniqueId: "soft-heart-steady-mind",
                    titleEN: "Soft Heart, Steady Mind",
                    titleES: "Corazón Suave Serena",
                    descriptionEN: "Gentle affirmations to calm racing thoughts and invite peace into the body.",
                    descriptionES: "Afirmaciones suaves para calmar pensamientos acelerados e invitar paz al cuerpo.",
                    imageName: "audio-art-9",
                    audioFileEN: "soft-heart-steady-mind-en.mp3",
                    audioFileES: "soft-heart-steady-mind-es.mp3",
                    category: .anxiety,
                    rating: 4.9
                )
            ]
            
        case .focus:
            return [
                Meditation(
                    uniqueId: "clear-the-fog",
                    titleEN: "Clear the Fog",
                    titleES: "Despeja la Niebla",
                    descriptionEN: "Sharpen your attention with mindful breathing and visualization techniques.",
                    descriptionES: "Afila tu atención con respiración consciente y técnicas de visualización.",
                    imageName: "audio-art-10",
                    audioFileEN: "clear-the-fog-en.mp3",
                    audioFileES: "clear-the-fog-es.mp3",
                    category: .focus,
                    rating: 4.1
                )
            ]
            
        case .gratitude:
            return [
                Meditation(
                    uniqueId: "grateful-heart",
                    titleEN: "Grateful Heart",
                    titleES: "Corazón Agradecido",
                    descriptionEN: "Reflect on what you appreciate in this moment and let gratitude fill you with warmth.",
                    descriptionES: "Reflexiona sobre lo que aprecias en este momento y deja que la gratitud te llene.",
                    imageName: "audio-art-13",
                    audioFileEN: "grateful-heart-en.mp3",
                    audioFileES: "grateful-heart-es.mp3",
                    category: .gratitude,
                    rating: 4.8
                )
            ]
        case .meditationMusic:
            let tracks = [
                "Celestial_Whispers",
                "Cosmic_Journey",
                "Ethereal_Waves",
                "Heavenly_Breeze",
                "Luminous_Dreams",
                "Peaceful_Cosmos",
                "Serene_Galaxy",
                "Starlight_Meditation",
                "Tranquil_Skies"
            ]
            let spanishTitles: [String: String] = [
                "Celestial_Whispers": "Susurros Celestiales",
                "Cosmic_Journey": "Viaje Cósmico",
                "Ethereal_Waves": "Olas Etéreas",
                "Heavenly_Breeze": "Brisa Celestial",
                "Luminous_Dreams": "Sueños Luminosos",
                "Peaceful_Cosmos": "Cosmos en Calma",
                "Serene_Galaxy": "Galaxia Serena",
                "Starlight_Meditation": "Meditación de Luz Estelar",
                "Tranquil_Skies": "Cielos Tranquilos"
            ]
            let audioArtImages = [
                "audio-art-1",
                "audio-art-10", // ensure the second track has a distinct artwork
                "audio-art-3",
                "audio-art-4",
                "audio-art-5",
                "audio-art-6",
                "audio-art-7",
                "audio-art-8",
                "audio-art-9"
            ]
            return tracks.enumerated().map { (index, track) in
                let displayName = track.replacingOccurrences(of: "_", with: " ")
                let spanishName = spanishTitles[track] ?? displayName
                let imageName = audioArtImages[index % audioArtImages.count]
                return Meditation(
                    uniqueId: "bg-\(track.lowercased())",
                    titleEN: displayName,
                    titleES: spanishName,
                    descriptionEN: "Ambient background music to accompany your meditation sessions.",
                    descriptionES: "Música ambiental para acompañar tus sesiones de meditación.",
                    imageName: imageName,
                    audioFileEN: "\(track).mp3",
                    audioFileES: "\(track).mp3",
                    category: .meditationMusic,
                    rating: 4.6
                )
            }
        }
    }
    
    // Get all meditations from all categories
    static var allMeditations: [Meditation] {
        var all: [Meditation] = []
        for category in CategoryType.allCases {
            if category != .favorites {
                all.append(contentsOf: meditations(for: category))
            }
        }
        return all
    }
    
    // Get favorites based on FavoritesManager
    static func favoritesMeditations(favoritesManager: FavoritesManager) -> [Meditation] {
        return allMeditations.filter { meditation in
            favoritesManager.isFavorite(meditation.uniqueId)
        }
    }
    
    // Find meditation by unique ID
    static func meditation(withId uniqueId: String) -> Meditation? {
        return allMeditations.first { $0.uniqueId == uniqueId }
    }
}
