//
//  FilmListView.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 28.12.2025..
//

import SwiftUI

struct FilmListView: View {
    
    var filmsViewModel: FilmsViewModel
    
    var body: some View {
        NavigationStack {
            switch filmsViewModel.state {
                case .idle:
                    Text("No Films Yet")
                case .loading:
                    ProgressView {
                        Text("Loading...")
                    }
                case .loaded(let films):
                    List(films) { film in
                        Text(film.title)
                    }
                case .error(let error):
                    Text(error)
                        .foregroundStyle(.pink)
            }
        }
        .task {
            await filmsViewModel.fetch()
        }
    }
}

#Preview {
    @State @Previewable var vm = FilmsViewModel(service: MockGhibliService())
    
    FilmListView(filmsViewModel: vm)
}
