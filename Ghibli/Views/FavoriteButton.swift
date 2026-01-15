//
//  FavoriteButton.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 03.01.2026..
//

import SwiftUI

struct FavoriteButton: View {
    
    let filmID: String
    let favoritesViewModel: FavoritesViewModel
    
    var isFavorite: Bool {
        favoritesViewModel.isFavorite(filmID: filmID)
    }
    
    var body: some View {
        Button {
            favoritesViewModel.toggleFavorite(filmID: filmID)
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(isFavorite ? Color.pink : Color.gray)
        }
        .accessibilityIdentifier(UIIdentifiers.favoriteButton)
        .accessibilityValue(isFavorite ? "favorited" : "not_favorited")
    }
}
