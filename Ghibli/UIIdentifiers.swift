//
//  UIIdentifiers.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 10.01.2026..
//

import Foundation

enum UIIdentifiers {
    
    enum FilmListScreen {
        static let filmList = "FilmListScreen.filmList"
        static let listItemButton = "FilmListScreen.list.item.click"
        
        static func item(_ id: String?) -> String {
            "FilmListScreen.film.\(id ?? "")"
        }
    }
    
    enum FilmDetailScreen {
        static let scrollView = "FilmDetailScreen.scrollView"
        static let image = "FilmDetailScreen.image"
        static let title = "FilmDetailScreen.title"
        static let info = "FilmDetailScreen.info"
        static let description = "FilmDetailScreen.description"
        static let characterSection = "FilmDetailScreen.characterSection"
    }
    
    enum FavoritesScreen {
        static let favoritesTab = "FavoritesScreen.favoritesTab"
        static let contentUnavailableView = "FavoritesScreen.contentUnavailableView"
    }
    
    enum SettingsScreen {
        static let settingsTab = "SettingsScreen.settingsTab"
        static let lightThemeButton = "SettingsScreen.lightThemeButton"
        static let darkThemeButton = "SettingsScreen.darkThemeButton"
        static let settingsPicker = "SettingsScreen.settingsPicker"
    }
    
    enum SearchScreen {
        static let searchTab = "SearchScreen.searchTab"
        //static let 
    }
    
    static let backButton = "button.back"
    static let favoriteButton = "button.favorite"
    
}
