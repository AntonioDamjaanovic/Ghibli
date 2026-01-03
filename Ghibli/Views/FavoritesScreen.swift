//
//  FavoritesScreen.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 31.12.2025..
//

import SwiftUI

struct FavoritesScreen: View {
    
    let filmsViewModel: FilmsViewModel
    let favoritesViewModel: FavoritesViewModel
    
    var films: [Film] {
        let favorites = favoritesViewModel.favoriteIDs
        switch filmsViewModel.state {
            case .loaded(let films):
                return films.filter { favorites.contains($0.id) }
            default:
                return []
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if films.isEmpty {
                    ContentUnavailableView("No Favorites Yet", systemImage: "heart")
                } else {
                    FilmListView(films: films, favoritesViewModel: favoritesViewModel)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesScreen(filmsViewModel: FilmsViewModel.example, favoritesViewModel: FavoritesViewModel.example)
}
