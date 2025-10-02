//
//  MeditationCard.swift
//  Meditation
//
//  Created by Cesar Vega on 10/2/25.
//

import SwiftUI

struct MeditationCard: View {
    let meditation: Meditation
    let categoryColor: Color
    let languageManager: LanguageManager
    
    var body: some View {
        HStack(spacing: 16) {
            // Audio art image with rounded corners
            Image(meditation.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Text content on the right
            VStack(alignment: .leading, spacing: 8) {
                Text(meditation.description(languageManager: languageManager))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(meditation.title(languageManager: languageManager))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Star rating
                HStack(spacing: 4) {
                    ForEach(0..<4) { _ in
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    Text(languageManager.currentLanguage == .spanish ? "2.3K reseñas" : "2.3K reviews")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .opacity(0.9)
        .padding(.horizontal, 16)
    }
}
