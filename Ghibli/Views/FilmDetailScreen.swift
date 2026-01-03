//
//  FilmDetailScreen.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 30.12.2025..
//

import SwiftUI

struct FilmDetailScreen: View {
    
    let film: Film
    let favoritesViewModel: FavoritesViewModel
    
    @State private var viewModel = FilmDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                FilmImageView(url: film.bannerImage)
                    .frame(height: 300)
                    .containerRelativeFrame(.horizontal)
                
                VStack(alignment: .leading) {
                    Text(film.title)
                    
                    Divider()
                    
                    Text("Characters:")
                        .font(.title3)
                    
                    switch viewModel.state {
                        case .idle:
                            EmptyView()
                            
                        case .loading:
                            ProgressView()
                            
                        case .loaded(let people):
                            ForEach(people) { person in
                                Text(person.name)
                            }
                            
                        case .error(let error):
                            Text(error)
                                .foregroundStyle(.pink)
                    }
                }
                .padding()
            }
            .toolbar {
                FavoriteButton(filmID: film.id, favoritesViewModel: favoritesViewModel)
                    .buttonStyle(.plain)
                    .controlSize(.large)
            }
            .task(id: film) {
                await viewModel.fetch(for: film)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FilmDetailScreen(film: Film.example, favoritesViewModel: FavoritesViewModel(service: MockFavoriteStorage()))
    }
}
