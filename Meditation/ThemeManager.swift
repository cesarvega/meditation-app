//
//  ThemeManager.swift
//  Meditation
//
//  Created by Cesar Vega on 10/3/25.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case pink
    case lightBlue
    case purple
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .pink:
            return "Pink"
        case .lightBlue:
            return "Light Blue"
        case .purple:
            return "Purple"
        }
    }

    var displayNameSpanish: String {
        switch self {
        case .pink:
            return "Rosa"
        case .lightBlue:
            return "Azul Claro"
        case .purple:
            return "Morado"
        }
    }

    var accentColor: Color {
        switch self {
        case .pink:
            return Color(red: 0.95, green: 0.75, blue: 0.85) // Soft pink/rose
        case .lightBlue:
            return Color(red: 0.68, green: 0.85, blue: 0.90) // Light blue
        case .purple:
            return Color(red: 0.68, green: 0.60, blue: 0.97) // Soft purple
        }
    }

    var toolbarColor: Color {
        switch self {
        case .pink:
            return Color(red: 0.90, green: 0.70, blue: 0.82) // Darker pink for toolbar
        case .lightBlue:
            return .cyan
        case .purple:
            return Color(red: 0.54, green: 0.46, blue: 0.85)
        }
    }
}

enum AvatarStyle: String, CaseIterable, Identifiable {
    case female
    case male
    
    var id: String { self.rawValue }
    
    var displayNameEnglish: String {
        switch self {
        case .female: return "Female"
        case .male: return "Male"
        }
    }
    
    var displayNameSpanish: String {
        switch self {
        case .female: return "Femenino"
        case .male: return "Masculino"
        }
    }
    
    var imageName: String {
        switch self {
        case .female: return "female"
        case .male: return "male"
        }
    }
}

@Observable
class ThemeManager {
    var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedTheme")
        }
    }
    
    var currentAvatar: AvatarStyle {
        didSet {
            UserDefaults.standard.set(currentAvatar.rawValue, forKey: "selectedAvatar")
        }
    }
    
    init() {
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? AppTheme.pink.rawValue
        self.currentTheme = AppTheme(rawValue: savedTheme) ?? .pink
        
        let savedAvatar = UserDefaults.standard.string(forKey: "selectedAvatar") ?? AvatarStyle.female.rawValue
        self.currentAvatar = AvatarStyle(rawValue: savedAvatar) ?? .female
    }
}
