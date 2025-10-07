//
//  CategoryCard.swift
//  Meditation
//
//  Created by Cesar Vega on 10/2/25.
//

import SwiftUI

struct CategoryCard: View {
    let category: Category
    let languageManager: LanguageManager
    let meditationCount: Int

    private var countLabel: String {
        meditationCount > 0 ? "1 to \(meditationCount)" : "0"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header section with category name and "1 to 10"
            HStack(spacing: 12) {
                Circle()
                    .fill(category.type == .favorites ? Color.blue.opacity(0.6) : category.color)
                    .frame(width: 8, height: 8)

                Text(category.name(languageManager: languageManager))
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer()

                Text(countLabel)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            // Content section with icon and description
            HStack(spacing: 16) {
                // Icon circle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    category.type == .favorites ? Color.blue.opacity(0.3) : category.color.opacity(0.6),
                                    category.type == .favorites ? Color.blue.opacity(0.6) : category.color
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                
                // Text content
                VStack(alignment: .leading, spacing: 6) {
                    Text(category.description(languageManager: languageManager))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
        )
        .opacity(0.8)
        .padding(.horizontal, 16)
    }
}

struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            
            VStack {
                CategoryCard(category: Category.allCategories[0], languageManager: LanguageManager(), meditationCount: 3)
                CategoryCard(category: Category.allCategories[1], languageManager: LanguageManager(), meditationCount: 1)
            }
        }
    }
}
