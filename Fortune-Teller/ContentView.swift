//
//  ContentView.swift
//  Fortune-Teller
//
//  Created by Cesar Vega on 9/23/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var languageManager = LanguageManager()
    @State private var showLanguagePicker = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Category.allCategories) { category in
                        CategoryCard(category: category, languageManager: languageManager)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .scrollContentBackground(.hidden)
            .background(
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea(.all)
            )
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(languageManager.localizedString(.welcome))
                            .font(.title2)
                            .foregroundColor(.white)
                        Text(languageManager.localizedString(.userName))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 30)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showLanguagePicker = true
                    }) {
                        Image(systemName: "globe")
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
            .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerView(languageManager: languageManager)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
