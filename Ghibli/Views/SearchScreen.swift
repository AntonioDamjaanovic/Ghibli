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
                        Text("Show search here")
                    case .loading:
                        ProgressView()
                    case .loaded(let films):
                        FilmListView(films: films, favoritesViewModel: favoritesViewModel)
                    case .error(let error):
                        Text(error)
                            .foregroundStyle(.pink)
                }
            }
            .searchable(text: $text)
            .task(id: text) {
                try? await Task.sleep(for: .milliseconds(500))
                guard !Task.isCancelled else { return }
                
                await searchViewModel.fetch(for: text)
            }
        }
    }
}

#Preview {
    SearchScreen(favoritesViewModel: FavoritesViewModel(service: MockFavoriteStorage()))
}
