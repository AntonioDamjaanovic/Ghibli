//
//  GhibliService.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 29.12.2025..
//

import Foundation

protocol GhibliService: Sendable {
    func fetchFilms() async throws -> [Film]
    func fetchPeople() async throws -> [Person]
    func fetchPerson(from URLString: String) async throws -> Person
    func searchFilm(for searchTerm: String) async throws -> [Film]
}
