//
//  Category.swift
//  Meditation
//
//  Created by Cesar Vega on 10/2/25.
//

import SwiftUI

enum CategoryType: String, CaseIterable {
    case favorites
    case sleep
    case stressRelief
    case anxiety
    case focus
    case gratitude
    case meditationMusic
    
    var icon: String {
        switch self {
        case .favorites: return "heart.fill"
        case .sleep: return "moon.stars.fill"
        case .stressRelief: return "heart.circle.fill"
        case .anxiety: return "leaf.fill"
        case .focus: return "brain.head.profile"
        case .gratitude: return "sparkles"
        case .meditationMusic: return "music.note.list"
        }
    }
    
    var color: Color {
        switch self {
        case .favorites: return .red
        case .sleep: return .indigo
        case .stressRelief: return .pink
        case .anxiety: return .green
        case .focus: return .orange
        case .gratitude: return .yellow
        case .meditationMusic: return .purple
        }
    }
    
    var nameKey: LocalizationKey {
        switch self {
        case .favorites: return .categoryFavorites
        case .sleep: return .categorySleep
        case .stressRelief: return .categoryStressRelief
        case .anxiety: return .categoryAnxiety
        case .focus: return .categoryFocus
        case .gratitude: return .categoryGratitude
        case .meditationMusic: return .categoryMeditationMusic
        }
    }
    
    var descriptionKey: LocalizationKey {
        switch self {
        case .favorites: return .descFavorites
        case .sleep: return .descSleep
        case .stressRelief: return .descStressRelief
        case .anxiety: return .descAnxiety
        case .focus: return .descFocus
        case .gratitude: return .descGratitude
        case .meditationMusic: return .descMeditationMusic
        }
    }
}

struct Category: Identifiable, Hashable {
    let id = UUID()
    let type: CategoryType

    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.type == rhs.type
    }
    
    func name(languageManager: LanguageManager) -> String {
        languageManager.localizedString(type.nameKey)
    }
    
    func description(languageManager: LanguageManager) -> String {
        languageManager.localizedString(type.descriptionKey)
    }
    
    var icon: String { type.icon }
    var color: Color { type.color }
    
    static let allCategories: [Category] = CategoryType.allCases.map { Category(type: $0) }
}
