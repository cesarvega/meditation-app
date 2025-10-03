//
//  FavoritesManager.swift
//  Meditation
//
//  Created by Cesar Vega on 10/2/25.
//

import SwiftUI
import Combine

@Observable
class FavoritesManager {
    private let favoritesKey = "FavoriteMeditations"
    private(set) var favoriteIds: Set<String> = []
    
    init() {
        loadFavorites()
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let ids = try? JSONDecoder().decode(Set<String>.self, from: data) {
            favoriteIds = ids
        }
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteIds) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
    
    func isFavorite(_ meditationId: String) -> Bool {
        return favoriteIds.contains(meditationId)
    }
    
    func toggleFavorite(_ meditationId: String) {
        if favoriteIds.contains(meditationId) {
            favoriteIds.remove(meditationId)
            print("❤️ Removed meditation from favorites: \(meditationId)")
        } else {
            favoriteIds.insert(meditationId)
            print("💖 Added meditation to favorites: \(meditationId)")
        }
        saveFavorites()
    }
    
    func addFavorite(_ meditationId: String) {
        if !favoriteIds.contains(meditationId) {
            favoriteIds.insert(meditationId)
            saveFavorites()
            print("💖 Added meditation to favorites: \(meditationId)")
        }
    }
    
    func removeFavorite(_ meditationId: String) {
        if favoriteIds.contains(meditationId) {
            favoriteIds.remove(meditationId)
            saveFavorites()
            print("❤️ Removed meditation from favorites: \(meditationId)")
        }
    }
    
    var hasFavorites: Bool {
        return !favoriteIds.isEmpty
    }
    
    var favoritesCount: Int {
        return favoriteIds.count
    }
}