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
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .pink:
            return "Pink"
        case .lightBlue:
            return "Light Blue"
        }
    }
    
    var displayNameSpanish: String {
        switch self {
        case .pink:
            return "Rosa"
        case .lightBlue:
            return "Azul Claro"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .pink:
            return Color(red: 0.95, green: 0.75, blue: 0.85) // Soft pink/rose
        case .lightBlue:
            return Color(red: 0.68, green: 0.85, blue: 0.90) // Light blue
        }
    }
    
    var toolbarColor: Color {
        switch self {
        case .pink:
            return Color(red: 0.90, green: 0.70, blue: 0.82) // Darker pink for toolbar
        case .lightBlue:
            return .cyan
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
    
    init() {
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? AppTheme.pink.rawValue
        self.currentTheme = AppTheme(rawValue: savedTheme) ?? .pink
    }
}
