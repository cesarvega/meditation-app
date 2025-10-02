//
//  LanguageManager.swift
//  Fortune-Teller
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
}

enum LocalizationKey {
    case welcome
    case userName
    case addItem
    case selectItem
    case language
    case chooseLanguage
    
    var english: String {
        switch self {
        case .welcome: return "Welcome,"
        case .userName: return "Jack Grealish"
        case .addItem: return "Add Item"
        case .selectItem: return "Select an item"
        case .language: return "Language"
        case .chooseLanguage: return "Choose Language"
        }
    }
    
    var spanish: String {
        switch self {
        case .welcome: return "Bienvenido,"
        case .userName: return "Jack Grealish"
        case .addItem: return "Agregar"
        case .selectItem: return "Selecciona un elemento"
        case .language: return "Idioma"
        case .chooseLanguage: return "Elegir Idioma"
        }
    }
}
