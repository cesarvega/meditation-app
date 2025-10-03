//
//  ContentView.swift
//  Meditation
//
//  Created by Cesar Vega on 9/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var languageManager = LanguageManager()
    @State private var showLanguagePicker = false
    @State private var refreshID = UUID()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Category.allCategories) { category in
                        NavigationLink(destination: CategoryDetailView(category: category, languageManager: languageManager)) {
                            CategoryCard(category: category, languageManager: languageManager)
                        }
                        .buttonStyle(PlainButtonStyle())
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
                    VStack(spacing: 2) {
                        Text(languageManager.localizedString(.welcome))
                            .font(.title2)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Text(languageManager.localizedString(.userName))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: 280)
                    }
                    .frame(height: 80)
                    .padding(.top, 30)
                    .id(refreshID)
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
            .onAppear {
                // Refresh toolbar when view appears
                refreshID = UUID()
            }
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
