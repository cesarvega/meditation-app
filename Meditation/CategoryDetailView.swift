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
    
    var meditations: [Meditation] {
        Meditation.meditations(for: category.type)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(meditations) { meditation in
                    MeditationCard(meditation: meditation, categoryColor: category.color, languageManager: languageManager)
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
