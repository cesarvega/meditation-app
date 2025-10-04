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
    @State private var showLogoutAlert = false
    @State private var refreshID = UUID()

    var body: some View {
        NavigationStack {
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
                                NavigationLink(destination: CategoryDetailView(category: category, languageManager: languageManager, themeManager: themeManager, favoritesManager: favoritesManager)) {
                                    CategoryCard(category: category, languageManager: languageManager)
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
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        if let user = authManager.currentUser {
                            HStack {
                                if let profileImageURL = user.profileImageURL,
                                   let url = URL(string: profileImageURL) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                    }
                                    .frame(width: 32, height: 32)
                                    .clipShape(Circle())
                                } else {
                                    // Use SF Symbol for demo user
                                    Image(systemName: "person.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                        .frame(width: 32, height: 32)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(user.name)
                                        .font(.headline)
                                    Text(user.email)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Divider()
                        }
                        
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        if let user = authManager.currentUser {
                            if let profileImageURL = user.profileImageURL,
                               let url = URL(string: profileImageURL) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Circle()
                                        .fill(Color.white.opacity(0.3))
                                }
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                            } else {
                                // Use SF Symbol for demo user (no profile image URL)
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .frame(width: 32, height: 32)
                            }
                        } else {
                            // Fallback if no user
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                    }
                }
        }
        .toolbarBackground(.clear, for: .navigationBar)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        .onAppear {
            // Refresh toolbar when view appears
            refreshID = UUID()
            NotificationManager.shared.scheduleDailyMeditationNotifications(language: languageManager.currentLanguage)
        }
        .onChange(of: languageManager.currentLanguage) { newLanguage in
            NotificationManager.shared.scheduleDailyMeditationNotifications(language: newLanguage)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(languageManager: languageManager, themeManager: themeManager)
        }
        .alert("Sign Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        authManager.signOut()
                    }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationManager())
    }
}
