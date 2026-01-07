//
//  SearchScreen.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 31.12.2025..
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var text: String = ""
    @State private var searchViewModel: SearchFilmsViewModel
    let favoritesViewModel: FavoritesViewModel
    
    init(service: GhibliService = DefaultGhibliService(), favoritesViewModel: FavoritesViewModel) {
        self.searchViewModel = SearchFilmsViewModel(service: service)
        self.favoritesViewModel = favoritesViewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch searchViewModel.state {
                    case .idle:
                        Text("Your search results will be shown here.")
                        .foregroundStyle(.secondary)
                    
                    case .loading:
                        ProgressView()
                    
                    case .loaded(let films):
                        FilmListView(films: films, favoritesViewModel: favoritesViewModel)
                    
                    case .error(let error):
                        Text(error)
                            .foregroundStyle(.pink)
                }
            }
            .navigationTitle("Search Ghibli Movies")
            .searchable(text: $text)
            .task(id: text) {
                await searchViewModel.fetch(for: text)
            }
        }
    }
}

#Preview {
    SearchScreen(favoritesViewModel: FavoritesViewModel(service: MockFavoriteStorage()))
}
