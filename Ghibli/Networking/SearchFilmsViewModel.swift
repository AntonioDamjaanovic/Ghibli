//
//  SearchFilmsViewModel.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 04.01.2026..
//

import Foundation
import Observation

@Observable
class SearchFilmsViewModel {
    
    var state: LoadingState<[Film]> = .idle
    
    private let service: GhibliService
    
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
    func fetch(for searchTerm: String) async {
        guard !searchTerm.isEmpty else {
            return
        }
        
        state = .loading
        
        do {
            let films = try await service.searchFilm(for: searchTerm)
            self.state = .loaded(films)
        } catch let error as APIError {
            self.state = .error(error.errorDescription ?? "Unknown error")
        } catch {
            self.state = .error("Unknown error")
        }
    }
    
    //MARK: - Preview
    static var example: FilmsViewModel {
            let vm = FilmsViewModel(service: MockGhibliService())
            vm.state = .loaded([Film.example, Film.exampleFavorite])
            return vm
    }
}
