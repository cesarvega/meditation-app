//
//  LanguagePickerView.swift
//  Fortune-Teller
//
//  Created by Cesar Vega on 10/2/25.
//

import SwiftUI

struct LanguagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var languageManager: LanguageManager
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(AppLanguage.allCases) { language in
                    Button(action: {
                        languageManager.currentLanguage = language
                        dismiss()
                    }) {
                        HStack {
                            Text(language.flag)
                                .font(.title)
                            Text(language.displayName)
                                .font(.title3)
                                .foregroundColor(.primary)
                            Spacer()
                            if languageManager.currentLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle(languageManager.localizedString(.chooseLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(languageManager.localizedString(.language) == "Language" ? "Done" : "Listo") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .toolbarBackground(.purple, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        }
    }
}

struct LanguagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        LanguagePickerView(languageManager: LanguageManager())
    }
}
