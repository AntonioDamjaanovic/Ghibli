//
//  GhibliTests.swift
//  GhibliTests
//
//  Created by Antonio Damjanović on 28.12.2025..
//

import Foundation
import Testing
@testable import Ghibli

struct GhibliTests {
    
    actor TestGhibliService: GhibliService {
        
        let mockFilms: [Film]
        let shouldThrowError: Bool
        let fetchDelay: Duration
        
        var fetchCallCount = 0
        var lastSearchQuery: String? = nil
        
        init(mockFilms: [Film], shouldThrowError: Bool = false, fetchDelay: Duration = .zero) {
            self.mockFilms = mockFilms
            self.shouldThrowError = shouldThrowError
            self.fetchDelay = fetchDelay
        }
        
        func fetchFilms() async throws -> [Film] {
            if shouldThrowError {
                throw APIError.networkError(NSError(domain: "Test", code: -1))
            }
            
            if fetchDelay > .zero {
                try? await Task.sleep(for: fetchDelay)
            }
            
            return mockFilms
        }
        
        func searchFilm(for searchTerm: String) async throws -> [Film] {
            self.fetchCallCount += 1
            self.lastSearchQuery = searchTerm
            
            if shouldThrowError {
                throw APIError.networkError(NSError(domain: "Test", code: -1))
            }
            
            if fetchDelay > .zero {
                try? await Task.sleep(for: fetchDelay)
            }
            
            try Task.checkCancellation()
            
            if searchTerm.isEmpty {
                return mockFilms
            }
            
            return mockFilms.filter { film in
                film.title.localizedStandardContains(searchTerm)
            }
        }
        
        func fetchPerson(from URLString: String) async throws -> Person {
            return Person(id: "", name: "", gender: "", age: "", eyeColor: "", hairColor: "", films: [], species: "", url: "")
        }
    }
    
    // MARK: - Test Data
     let mockFilms = [
         Film(
             id: "1",
             title: "My Neighbor Totoro",
             description: "Two sisters discover Totoro",
             director: "Hayao Miyazaki",
             producer: "Isao Takahata",
             releaseYear: "1988",
             score: "93",
             duration: "",
             image: "",
             bannerImage: "",
             people: []
         ),
         Film(
             id: "2",
             title: "Spirited Away",
             description: "A girl enters a spirit world",
             director: "Hayao Miyazaki",
             producer: "Toshio Suzuki",
             releaseYear: "2001",
             score: "97",
             duration: "",
             image: "",
             bannerImage: "",
             people: []
         ),
         Film(
             id: "3",
             title: "Princess Mononoke",
             description: "A prince fights to save the forest",
             director: "Hayao Miyazaki",
             producer: "Toshio Suzuki",
             releaseYear: "1997",
             score: "92",
             duration: "",
             image: "",
             bannerImage: "",
             people: []
         )
     ]

    @MainActor
    @Test func testInitialState() async throws {
        let service = TestGhibliService(mockFilms: mockFilms)
        let viewModel = SearchFilmsViewModel(service: service)
        
        #expect(viewModel.state.data == nil)
        
        if case .idle = viewModel.state {
            
        } else {
            Issue.record("Expected idle state")
        }
    }
    
    @MainActor
    @Test("Search with query filter results")
    func testSearchWithQuery() async {
        let service = TestGhibliService(mockFilms: mockFilms)
        let viewModel = SearchFilmsViewModel(service: service)
        
        await viewModel.fetch(for: "Totoro")
        
        #expect(viewModel.state.data?.count == 1)
        #expect(viewModel.state.data?.first?.title == "My Neighbor Totoro")
    }

    @MainActor
    @Test("Search result gives error")
    func testSearchWithError() async {
        let service = TestGhibliService(mockFilms: mockFilms, shouldThrowError: true)
        let viewModel = SearchFilmsViewModel(service: service)
        
        await viewModel.fetch(for: "Totoro")
        
        #expect(viewModel.state.error != nil)
    }
    
    @MainActor
    @Test("Task cancellation after API call prevents state update")
    func testCancellationAfterAPICall() async {
        let service = TestGhibliService(mockFilms: mockFilms, fetchDelay: .milliseconds(100))
        let viewModel = SearchFilmsViewModel(service: service)
        
        let task = Task {
            await viewModel.fetch(for: "tot")
        }
        
        try? await Task.sleep(for: .milliseconds(550))
        task.cancel()
        
        await task.value
        
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 1)
        
        let lastSearchQuery = await service.lastSearchQuery
        #expect(lastSearchQuery == "tot")
        
        #expect(viewModel.state.error != nil)
    }
    
    @MainActor
    @Test("Test that task is not fetching to frequently")
    func testDebounceTiming() async {
        let service = TestGhibliService(mockFilms: mockFilms, fetchDelay: .milliseconds(100))
        let viewModel = SearchFilmsViewModel(service: service)
        
        let task = Task {
            await viewModel.fetch(for: "tot")
        }
        
        // cancel before debounce timing of 500ms is over
        try? await Task.sleep(for: .milliseconds(450))
        task.cancel()
        
        await task.value
        
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 0)
        
        let lastSearchQuery = await service.lastSearchQuery
        #expect(lastSearchQuery == nil)
        
        #expect(viewModel.state == .idle)
    }
    
    @MainActor
    @Test("Multiple rapid searches only execute the last one")
    func testDebounceWithFastMultipleSearches() async {
        let service = TestGhibliService(mockFilms: mockFilms)
        let viewModel = SearchFilmsViewModel(service: service)
        
        // simulate rapid typing: "t", "to", "tot", "toto", "totor", "totoro"
        let searchQueries = ["t", "to", "tot", "toto", "totor", "totoro"]
        var tasks: [Task<Void, Never>] = []
        
        for query in searchQueries {
            // cancel previous task
            tasks.last?.cancel()
            
            let task = Task {
                await viewModel.fetch(for: query)
            }
            tasks.append(task)
            
            // small delay between keystrokes
            try? await Task.sleep(for: .milliseconds(50)) // shorter than 500ms debounce rate set in search view model
        }
        
        // wait for the last task to complete
        await tasks.last?.value
        
        let fetchCallCount = await service.fetchCallCount
        let lastSearchQuery = await service.lastSearchQuery
        
        #expect(fetchCallCount == 1, "Only the final search should execute")
        #expect(lastSearchQuery == "totoro", "Should search for the final query")
        #expect(viewModel.state.data?.count == 1)
        #expect(viewModel.state.data?.first?.title == "My Neighbor Totoro")
    }
    
    @MainActor
    @Test("Multiple slow searches execute all")
    func testDebounceWithSlowMultipleSearches() async {
        let service = TestGhibliService(mockFilms: mockFilms)
        let viewModel = SearchFilmsViewModel(service: service)
        
        // simulate slow typing: "tot", "totor", "totoro"
        let searchQueries = ["tot", "totor", "totoro"]
        var tasks: [Task<Void, Never>] = []
        
        for query in searchQueries {
            // cancel previous task
            tasks.last?.cancel()
            
            let task = Task {
                await viewModel.fetch(for: query)
            }
            tasks.append(task)
            
            // small delay between keystrokes
            try? await Task.sleep(for: .milliseconds(550)) // longer than 500ms debounce rate set in search view model
        }
        
        // wait for the last task to complete
        await tasks.last?.value
        
        let fetchCallCount = await service.fetchCallCount
        let lastSearchQuery = await service.lastSearchQuery
        
        #expect(fetchCallCount == 3, "All searches should execute")
        #expect(lastSearchQuery == "totoro", "Should search for the final query")
        #expect(viewModel.state.data?.count == 1)
        #expect(viewModel.state.data?.first?.title == "My Neighbor Totoro")
    }
}
