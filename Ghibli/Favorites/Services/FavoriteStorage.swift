//
//  FavoriteStorage.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 02.01.2026..
//

import Foundation

protocol FavoriteStorage {
    func load() -> Set<String>
    func save(favoriteIDs: Set<String>)
}
