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
            VStack(alignment: .leading, spacing: 8) {
                FilmImageView(url: film.bannerImage)
                    .frame(height: 300)
                    .containerRelativeFrame(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(film.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Grid(alignment: .leading) {
                        InfoRow(label: "Director", value: film.director)
                        InfoRow(label: "Producer", value: film.producer)
                        InfoRow(label: "Release Date", value: film.releaseYear)
                        InfoRow(label: "Running Time", value: "\(film.duration) minutes")
                        InfoRow(label: "Score", value: "\(film.score)/100")
                    }
                    .padding(.vertical, 8)
                    
                    Divider()
                    
                    Text("Description:")
                        .font(.headline)
                    
                    Text(film.description)
                    
                    Divider()
                    
                    CharacterSection(viewModel: viewModel)
                }
                .padding()
            }
        }
        .toolbar {
            FavoriteButton(filmID: film.id, favoritesViewModel: favoritesViewModel)
                .buttonStyle(.plain)
                .controlSize(.large)
        }
        .task(id: film) {
            await viewModel.fetch(for: film, filmUrl: film.url)
        }
    }
}

fileprivate struct InfoRow: View {
    
    let label: String
    let value: String
    
    var body: some View {
        GridRow {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
        }
    }
}

fileprivate struct CharacterSection: View {
    
    let viewModel: FilmDetailViewModel
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Text("Characters")
                    .font(.headline)
                
                switch viewModel.state {
                    case .idle:
                        EmptyView()
                        
                    case .loading:
                        ProgressView()
                        
                    case .loaded(let people):
                        if people.isEmpty {
                            Text("Characters can't be shown at this moment.")
                                .foregroundStyle(.pink)
                        } else {
                            ForEach(people) { person in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(person.name)
                                    
                                    HStack(spacing: 8) {
                                        Label(person.gender, systemImage: "person.fill")
                                        Text("Age: \(person.age)")
                                        
                                        Spacer()
                                        
                                        Label(person.eyeColor, systemImage: "eye")
                                        Text("Hair: \(person.hairColor)")
                                    }
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                    .lineLimit(1)
                                }
                            }
                        }
                    
                    case .error(let error):
                        Text(error)
                            .foregroundStyle(.pink)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FilmDetailScreen(film: Film.example, favoritesViewModel: FavoritesViewModel(service: MockFavoriteStorage()))
    }
}
