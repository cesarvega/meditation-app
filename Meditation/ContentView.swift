//
//  ContentView.swift
//  Meditation
//
//  Created by Cesar Vega on 9/23/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var languageManager = LanguageManager()
    @State private var themeManager = ThemeManager()
    @State private var favoritesManager = FavoritesManager()
    @State private var showSettings = false
    @State private var refreshID = UUID()
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { proxy in
                let safeTop = proxy.safeAreaInsets.top
                let adjustedTop = max(safeTop - 106, 0)
                let headerHeight: CGFloat = 84
                
                ZStack(alignment: .top) {
                    Image("BackgroundImage")
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .clipped()
                        .ignoresSafeArea(.all)

                    HStack {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.25))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.top, adjustedTop + 12)
                    .padding(.horizontal, 20)
                    .zIndex(2)

                    VStack(spacing: 2) {
                        Text(languageManager.localizedString(.welcome))
                            .font(.title2)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Text(authManager.currentUser?.name ?? languageManager.userName(for: themeManager.currentTheme))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: 280)
                    }
                    .padding(.top, adjustedTop)
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity)
                    .background(Color.clear)
                    .id(refreshID)

                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(Category.allCategories) { category in
                                NavigationLink(value: category) {
                                    CategoryCard(
                                        category: category,
                                        languageManager: languageManager,
                                        meditationCount: meditationCount(for: category)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.top, 6)
                        .padding(.bottom, 26)
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.top, adjustedTop + headerHeight)
                    .zIndex(1)
                }
            }
            .navigationDestination(for: Category.self) { category in
                CategoryDetailView(
                    category: category,
                    languageManager: languageManager,
                    themeManager: themeManager,
                    favoritesManager: favoritesManager
                )
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.clear, for: .navigationBar)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        .onAppear {
            // Refresh toolbar when view appears
            refreshID = UUID()
            NotificationManager.shared.scheduleDailyMeditationNotifications(language: languageManager.currentLanguage)
        }
        .onChange(of: languageManager.currentLanguage) { _, newLanguage in
            NotificationManager.shared.scheduleDailyMeditationNotifications(language: newLanguage)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(languageManager: languageManager, themeManager: themeManager)
        }
        .onReceive(NotificationCenter.default.publisher(for: .openMeditation)) { notification in
            if let meditationId = notification.userInfo?["meditation_id"] as? String {
                handleDeepLink(meditationId: meditationId)
            }
        }
    }

    private func handleDeepLink(meditationId: String) {
        guard let meditation = Meditation.meditation(withId: meditationId) else { return }

        // Find the category for this meditation
        let category = Category.allCategories.first { $0.type == meditation.category }

        if let category = category {
            openCategory(category, meditationId: meditationId)
        }
    }

    private func openCategory(_ category: Category, meditationId: String? = nil) {
        var newPath = NavigationPath()
        newPath.append(category)
        if let meditationId,
           let meditation = Meditation.meditation(withId: meditationId) {
            newPath.append(meditation)
        }
        navigationPath = newPath
    }

    private func meditationCount(for category: Category) -> Int {
        switch category.type {
        case .favorites:
            return Meditation.favoritesMeditations(favoritesManager: favoritesManager).count
        default:
            return Meditation.meditations(for: category.type).count
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationManager())
    }
}
