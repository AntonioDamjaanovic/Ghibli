//
//  FilmListView.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 28.12.2025..
//

import SwiftUI

struct FilmListView: View {
    
    var films: [Film]
    
    var body: some View {
        List(films) { film in
            NavigationLink(value: film) {
                HStack {
                    FilmImageView(url: film.image)
                        .frame(width: 100, height: 150)
                    
                    Text(film.title)
                }
            }
        }
        .navigationDestination(for: Film.self) { film in
            FilmDetailScreen(film: film)
        }
    }
}
/*
#Preview("Mocked Film List") {
    @State @Previewable var vm = FilmsViewModel(service: MockGhibliService())
    
    FilmListView(filmsViewModel: vm)
}

#Preview("Real Film List") {
    @State @Previewable var vm = FilmsViewModel(service: DefaultGhibliService())
    
    FilmListView(filmsViewModel: vm)
}
*/
