//
//  CategoryCard.swift
//  Fortune-Teller
//
//  Created by Cesar Vega on 10/2/25.
//

import SwiftUI

struct CategoryCard: View {
    let category: Category
    let languageManager: LanguageManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header section with category name and "1 to 10"
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(category.color)
                        .frame(width: 8, height: 8)
                    
                    Text(category.name(languageManager: languageManager))
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                Text("1 to 10")
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
                                gradient: Gradient(colors: [category.color.opacity(0.6), category.color]),
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
                    
                    Text("Today 8.00 PM")
                        .font(.subheadline)
                        .foregroundColor(.gray)
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
                CategoryCard(category: Category.allCategories[0], languageManager: LanguageManager())
                CategoryCard(category: Category.allCategories[1], languageManager: LanguageManager())
            }
        }
    }
}
