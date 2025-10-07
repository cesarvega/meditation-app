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
    let themeManager: ThemeManager
    let favoritesManager: FavoritesManager
    @Environment(\.presentationMode) var presentationMode
    
    var meditations: [Meditation] {
        if category.type == .favorites {
            return Meditation.favoritesMeditations(favoritesManager: favoritesManager)
        } else {
            return Meditation.meditations(for: category.type)
        }
    }
    
    private func clearAllFavorites() {
        for meditation in meditations {
            favoritesManager.removeFavorite(meditation.uniqueId)
        }
    }
    
    var body: some View {
        Group {
            if category.type == .favorites {
                // Use List for favorites to enable swipe actions
                if meditations.isEmpty {
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(meditations) { meditation in
                            MeditationCard(meditation: meditation, categoryColor: category.color, languageManager: languageManager, themeManager: themeManager, favoritesManager: favoritesManager)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            favoritesManager.removeFavorite(meditation.uniqueId)
                                        }
                                    }) {
                                        Label(
                                            languageManager.currentLanguage == .spanish ? "Eliminar" : "Delete",
                                            systemImage: "heart.slash.fill"
                                        )
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }
            } else {
                // Use ScrollView for other categories
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(meditations) { meditation in
                            MeditationCard(meditation: meditation, categoryColor: category.color, languageManager: languageManager, themeManager: themeManager, favoritesManager: favoritesManager)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .background(
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea(.all)
        )
    // Use a custom inline title with back button so title appears on the same line as the back button
    .navigationBarTitleDisplayMode(.large)
    .navigationBarBackButtonHidden(true)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.clear, for: .navigationBar)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        .toolbar {
            // Leading custom back button + inline title
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 12) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    Text(category.name(languageManager: languageManager))
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
            }

            if category.type == .favorites && !meditations.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: clearAllFavorites) {
                        Text(languageManager.currentLanguage == .spanish ? "Limpiar" : "Clear All")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationDestination(for: Meditation.self) { meditation in
            AudioPlayerView(
                meditation: meditation,
                categoryColor: category.color,
                languageManager: languageManager,
                themeManager: themeManager,
                favoritesManager: favoritesManager
            )
        }
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
