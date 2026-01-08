//
//  FilmDetailViewModel.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 29.12.2025..
//

import Foundation
import Observation

@Observable
class FilmDetailViewModel {

    var state: LoadingState<[Person]> = .idle
    
    private let service: GhibliService
    
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
    func fetch(for film: Film, filmUrl: String) async {
        guard !state.isLoading else { return }
        
        state = .loading
        
        do {
            let allPeople = try await service.fetchPeople()
            
            let peopleInFilm = allPeople.filter { person in
                person.films.contains(filmUrl)
            }
            self.state = .loaded(peopleInFilm)
        } catch let error as APIError {
            self.state = .error(error.errorDescription ?? "Unknown error")
        } catch {
            self.state = .error("Unknown error")
        }
    }
}

import Playgrounds

#Playground {
    let service = MockGhibliService()
    let vm = FilmDetailViewModel(service: service)
    
    let film = service.fetchFilm()
    await vm.fetch(for: film, filmUrl: "")
    
    switch vm.state {
        case .idle:
            print("idle")
        case .loading:
            print("loading")
        case .loaded(let people):
            for person in people {
                print(person)
            }
        case .error(let error):
            print(error)
    }
}
