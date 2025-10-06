//
//  LanguageManager.swift
//  Meditation
//
//  Created by Cesar Vega on 10/2/25.
//

import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        }
    }
    
    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .spanish: return "🇪🇸"
        }
    }
}

@Observable
class LanguageManager {
    var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = AppLanguage(rawValue: savedLanguage) {
            self.currentLanguage = language
        } else {
            self.currentLanguage = .english
        }
    }
    
    // Localized strings
    func localizedString(_ key: LocalizationKey) -> String {
        switch currentLanguage {
        case .english:
            return key.english
        case .spanish:
            return key.spanish
        }
    }
    
    // Get user name based on theme
    func userName(for theme: AppTheme) -> String {
        switch (currentLanguage, theme) {
        case (.english, .pink):
            return "Sophie Anderson"
        case (.spanish, .pink):
            return "Sofía Martínez"
        case (.english, .lightBlue):
            return "Jack Grealish"
        case (.spanish, .lightBlue):
            return "Carlos Rodríguez"
        case (.english, .purple):
            return "Ava Thompson"
        case (.spanish, .purple):
            return "Valentina Morales"
        }
    }
}

enum LocalizationKey {
    case welcome
    case userName
    case language
    case chooseLanguage
    
    // Category names
    case categoryFavorites
    case categorySleep
    case categoryStressRelief
    case categoryAnxiety
    case categoryFocus
    case categoryGratitude
    
    // Category descriptions
    case descFavorites
    case descSleep
    case descStressRelief
    case descAnxiety
    case descFocus
    case descGratitude
    
    var english: String {
        switch self {
        case .welcome: return "Welcome,"
        case .userName: return "Jack Grealish"
        case .language: return "Language"
        case .chooseLanguage: return "Choose Language"
        
        // Categories
        case .categoryFavorites: return "Favorites"
        case .categorySleep: return "Sleep"
        case .categoryStressRelief: return "Stress Relief"
        case .categoryAnxiety: return "Anxiety"
        case .categoryFocus: return "Focus"
        case .categoryGratitude: return "Gratitude"
        
        // Descriptions
        case .descFavorites: return "Your favorite meditations"
        case .descSleep: return "To help you relax and go to sleep"
        case .descStressRelief: return "Techniques to reduce your daily stress"
        case .descAnxiety: return "Calming exercises for peace of mind"
        case .descFocus: return "Improve concentration and mental clarity"
        case .descGratitude: return "Practice mindfulness and appreciation"
        }
    }
    
    var spanish: String {
        switch self {
        case .welcome: return "Bienvenido,"
        case .userName: return "Jack Grealish"
        case .language: return "Idioma"
        case .chooseLanguage: return "Elegir Idioma"
        
        // Categories
        case .categoryFavorites: return "Favoritos"
        case .categorySleep: return "Dormir"
        case .categoryStressRelief: return "Alivio del Estrés"
        case .categoryAnxiety: return "Ansiedad"
        case .categoryFocus: return "Enfoque"
        case .categoryGratitude: return "Gratitud"
        
        // Descriptions
        case .descFavorites: return "Tus meditaciones favoritas"
        case .descSleep: return "Para ayudarte a relajarte y dormir"
        case .descStressRelief: return "Técnicas para reducir el estrés diario"
        case .descAnxiety: return "Ejercicios calmantes para la paz mental"
        case .descFocus: return "Mejora la concentración y claridad mental"
        case .descGratitude: return "Practica la atención plena y el agradecimiento"
        }
    }
}
