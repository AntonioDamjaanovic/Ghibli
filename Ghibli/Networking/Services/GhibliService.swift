//
//  GhibliService.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 29.12.2025..
//

import Foundation

protocol GhibliService {
    func fetchFilms() async throws -> [Film]
    func fetchPerson(from URLString: String) async throws -> Person
}
