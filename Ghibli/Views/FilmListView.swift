//
//  FilmListView.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 28.12.2025..
//

import SwiftUI

struct FilmListView: View {
    
    var films: [Film]
    let favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        List(films) { film in
            NavigationLink(value: film) {
                FilmRow(film: film, favoritesViewModel: favoritesViewModel)
            }
        }
        .navigationDestination(for: Film.self) { film in
            FilmDetailScreen(film: film, favoritesViewModel: favoritesViewModel)
        }
    }
}

private struct FilmRow: View {
    
    let film: Film
    let favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            FilmImageView(url: film.image)
                .frame(width: 100, height: 150)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(film.title)
                        .bold()
                    
                    Spacer()
                    
                    FavoriteButton(filmID: film.id, favoritesViewModel: favoritesViewModel)
                        .buttonStyle(.plain)
                        .controlSize(.large)
                }
                .padding(.bottom)
                
                Text("Directed by \(film.director)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Released: \(film.releaseYear)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
        }
    }
}

#Preview {
    //@State @Previewable var filmsViewModel = FilmsViewModel(service: MockGhibliService())
    @State @Previewable var favorites = FavoritesViewModel(service: MockFavoriteStorage())
    
    NavigationStack {
        FilmListView(films: [Film.example, Film.exampleFavorite],
                     favoritesViewModel: favorites)
    }
    .task {
        favorites.load()
    }
}

