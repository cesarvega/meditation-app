//
//  CategoryDetailView.swift
//  Meditation
//
//  Created by Cesar Vega on 10/2/25.
//

import SwiftUI

struct CategoryDetailView: View {
    let category: Category
    let languageManager: LanguageManager
    let favoritesManager: FavoritesManager
    
    var meditations: [Meditation] {
        if category.type == .favorites {
            return Meditation.favoritesMeditations(favoritesManager: favoritesManager)
        } else {
            return Meditation.meditations(for: category.type)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if category.type == .favorites && meditations.isEmpty {
                    // Show empty favorites message
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(languageManager.currentLanguage == .spanish ? "No hay favoritos seleccionados aún" : "No Favorites Selected Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(languageManager.currentLanguage == .spanish ? "Toca el ícono de marcador en cualquier meditación para agregarla a tus favoritos" : "Tap the bookmark icon on any meditation to add it to your favorites")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 100)
                } else {
                    ForEach(meditations) { meditation in
                        MeditationCard(meditation: meditation, categoryColor: category.color, languageManager: languageManager, favoritesManager: favoritesManager)
                    }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea(.all)
        )
        .navigationTitle(category.name(languageManager: languageManager))
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.clear, for: .navigationBar)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
        }
    }
}
