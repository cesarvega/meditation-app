//
//  SettingsView.swift
//  Meditation
//
//  Created by Cesar Vega on 10/3/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @Bindable var languageManager: LanguageManager
    @Bindable var themeManager: ThemeManager
    @State private var showingProfileEdit = false
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                Section {
                    Button(action: {
                        showingProfileEdit = true
                    }) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                                .foregroundColor(themeManager.currentTheme.accentColor)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Edit Profile")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Text(authManager.currentUser?.name ?? "User")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text(languageManager.currentLanguage == .spanish ? "Perfil" : "Profile")
                        .font(.headline)
                }
                
                // Language Section
                Section {
                    ForEach(AppLanguage.allCases) { language in
                        Button(action: {
                            languageManager.currentLanguage = language
                        }) {
                            HStack {
                                Text(language.flag)
                                    .font(.title2)
                                Text(language.displayName)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Spacer()
                                if languageManager.currentLanguage == language {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(themeManager.currentTheme.accentColor)
                                        .fontWeight(.bold)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } header: {
                    Text(languageManager.currentLanguage == .spanish ? "Idioma" : "Language")
                        .font(.headline)
                }
                
                // Theme Section
                Section {
                    ForEach(AppTheme.allCases) { theme in
                        Button(action: {
                            themeManager.currentTheme = theme
                        }) {
                            HStack {
                                // Color circle preview
                                Circle()
                                    .fill(theme.accentColor)
                                    .frame(width: 30, height: 30)
                                
                                Text(languageManager.currentLanguage == .spanish ? 
                                     theme.displayNameSpanish : theme.displayName)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if themeManager.currentTheme == theme {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(themeManager.currentTheme.accentColor)
                                        .fontWeight(.bold)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } header: {
                    Text(languageManager.currentLanguage == .spanish ? "Tema" : "Theme")
                        .font(.headline)
                }
            }
            .navigationTitle(languageManager.currentLanguage == .spanish ? "Configuración" : "Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(languageManager.currentLanguage == .spanish ? "Listo" : "Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .toolbarBackground(themeManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(languageManager: LanguageManager(), themeManager: ThemeManager())
    }
}
