//
//  ContentView.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 28.12.2025..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Movies", systemImage: "movieclapper") {
                FilmsScreen()
            }
            
            Tab("Favorites", systemImage: "heart") {
                FavoritesScreen()
            }
            
            Tab("Settings", systemImage: "gear") {
                SettingsScreen()
            }
            Tab(role: .search) {
                SearchScreen()
            }
        }
    }
}

#Preview {
    ContentView()
}
