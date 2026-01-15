//
//  ContentView.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 28.12.2025..
//

import SwiftUI

struct ContentView: View {
    
    @State private var filmsViewModel = FilmsViewModel()
    @State private var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        TabView {
            Tab("Movies", systemImage: "movieclapper") {
                FilmsScreen(filmsViewModel: filmsViewModel, favoritesViewModel: favoritesViewModel)
            }
            
            Tab("Favorites", systemImage: "heart") {
                FavoritesScreen(filmsViewModel: filmsViewModel, favoritesViewModel: favoritesViewModel)
            }
            .accessibilityIdentifier(UIIdentifiers.FavoritesScreen.favoritesTab)
            
            Tab("Settings", systemImage: "gear") {
                SettingsScreen()
            }
            .accessibilityIdentifier(UIIdentifiers.SettingsScreen.settingsTab)
            
            Tab(role: .search) {
                SearchScreen(favoritesViewModel: favoritesViewModel)
            }
            .accessibilityIdentifier(UIIdentifiers.SearchScreen.searchTab)
        }
        .task {
            await filmsViewModel.fetch()
            favoritesViewModel.load()
        }
        .setAppearanceTheme()
    }
}

#Preview {
    ContentView()
}
