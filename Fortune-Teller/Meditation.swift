//
//  Meditation.swift
//  Fortune-Teller
//
//  Created by Cesar Vega on 10/2/25.
//

import Foundation

struct Meditation: Identifiable {
    let id = UUID()
    let titleEN: String
    let titleES: String
    let descriptionEN: String
    let descriptionES: String
    let imageName: String
    
    func title(languageManager: LanguageManager) -> String {
        languageManager.currentLanguage == .spanish ? titleES : titleEN
    }
    
    func description(languageManager: LanguageManager) -> String {
        languageManager.currentLanguage == .spanish ? descriptionES : descriptionEN
    }
    
    static func meditations(for category: CategoryType) -> [Meditation] {
        switch category {
        case .sleep:
            return [
                Meditation(
                    titleEN: "Peaceful Drift",
                    titleES: "Deriva Pacífica",
                    descriptionEN: "Gently guide your mind and body into deep rest with calming breath and soft visualization.",
                    descriptionES: "Guía suavemente tu mente y cuerpo hacia el descanso profundo con respiración calmante.",
                    imageName: "audio-art-1"
                ),
                Meditation(
                    titleEN: "Night Ocean Waves",
                    titleES: "Olas del Océano Nocturno",
                    descriptionEN: "A soothing meditation using imagery of the sea to release tension and invite sleep.",
                    descriptionES: "Una meditación relajante usando imágenes del mar para liberar tensión e invitar al sueño.",
                    imageName: "audio-art-2"
                ),
                Meditation(
                    titleEN: "Release the Day",
                    titleES: "Libera el Día",
                    descriptionEN: "Let go of thoughts, worries, and busyness as you prepare for a restorative night's rest.",
                    descriptionES: "Deja ir pensamientos y preocupaciones mientras te preparas para un descanso reparador.",
                    imageName: "audio-art-3"
                )
            ]
            
        case .stressRelief:
            return [
                Meditation(
                    titleEN: "Unwind the Mind",
                    titleES: "Relaja la Mente",
                    descriptionEN: "Ease mental tension with gentle breathing and body relaxation.",
                    descriptionES: "Alivia la tensión mental con respiración suave y relajación corporal.",
                    imageName: "audio-art-4"
                ),
                Meditation(
                    titleEN: "Melting the Pressure",
                    titleES: "Derritiendo la Presión",
                    descriptionEN: "A calming practice to soften stress, letting it dissolve from head to toe.",
                    descriptionES: "Una práctica calmante para suavizar el estrés, dejándolo disolverse de pies a cabeza.",
                    imageName: "audio-art-5"
                ),
                Meditation(
                    titleEN: "Quiet Center",
                    titleES: "Centro Tranquilo",
                    descriptionEN: "Find your inner stillness by focusing on breath and grounding awareness.",
                    descriptionES: "Encuentra tu quietud interior enfocándote en la respiración y la conciencia.",
                    imageName: "audio-art-6"
                )
            ]
            
        case .anxiety:
            return [
                Meditation(
                    titleEN: "Calm in the Storm",
                    titleES: "Calma en la Tormenta",
                    descriptionEN: "Learn to anchor yourself in the present when anxiety feels overwhelming.",
                    descriptionES: "Aprende a anclarte en el presente cuando la ansiedad se siente abrumadora.",
                    imageName: "audio-art-7"
                ),
                Meditation(
                    titleEN: "Ground & Breathe",
                    titleES: "Enraízate y Respira",
                    descriptionEN: "A simple practice to steady the mind and reconnect to safety through the breath.",
                    descriptionES: "Una práctica simple para estabilizar la mente y reconectar con la seguridad.",
                    imageName: "audio-art-8"
                ),
                Meditation(
                    titleEN: "Soft Heart, Steady Mind",
                    titleES: "Corazón Suave, Mente Firme",
                    descriptionEN: "Gentle affirmations to calm racing thoughts and invite peace into the body.",
                    descriptionES: "Afirmaciones suaves para calmar pensamientos acelerados e invitar paz al cuerpo.",
                    imageName: "audio-art-9"
                )
            ]
            
        case .focus:
            return [
                Meditation(
                    titleEN: "Clear the Fog",
                    titleES: "Despeja la Niebla",
                    descriptionEN: "Sharpen your attention with mindful breathing and visualization techniques.",
                    descriptionES: "Afila tu atención con respiración consciente y técnicas de visualización.",
                    imageName: "audio-art-10"
                ),
                Meditation(
                    titleEN: "Laser Focus",
                    titleES: "Enfoque Láser",
                    descriptionEN: "Guide your energy into one point of concentration for productivity and clarity.",
                    descriptionES: "Guía tu energía en un punto de concentración para productividad y claridad.",
                    imageName: "audio-art-11"
                ),
                Meditation(
                    titleEN: "Present Power",
                    titleES: "Poder Presente",
                    descriptionEN: "A short meditation to pull your mind back from distractions and into the task at hand.",
                    descriptionES: "Una meditación corta para traer tu mente de las distracciones a la tarea presente.",
                    imageName: "audio-art-12"
                )
            ]
            
        case .gratitude:
            return [
                Meditation(
                    titleEN: "Grateful Heart",
                    titleES: "Corazón Agradecido",
                    descriptionEN: "Reflect on what you appreciate in this moment and let gratitude fill you with warmth.",
                    descriptionES: "Reflexiona sobre lo que aprecias en este momento y deja que la gratitud te llene.",
                    imageName: "audio-art-13"
                ),
                Meditation(
                    titleEN: "Seeds of Joy",
                    titleES: "Semillas de Alegría",
                    descriptionEN: "A meditation to notice life's small blessings and expand your sense of abundance.",
                    descriptionES: "Una meditación para notar las pequeñas bendiciones y expandir tu sentido de abundancia.",
                    imageName: "audio-art-14"
                ),
                Meditation(
                    titleEN: "Circle of Thanks",
                    titleES: "Círculo de Gratitud",
                    descriptionEN: "Extend gratitude outward—to people, experiences, and the world around you.",
                    descriptionES: "Extiende gratitud hacia afuera—a personas, experiencias y el mundo que te rodea.",
                    imageName: "audio-art-15"
                )
            ]
        }
    }
}
