//
//  GhibliUITests.swift
//  GhibliUITests
//
//  Created by Antonio Damjanović on 28.12.2025..
//

import XCTest

final class GhibliUITests: XCTestCase {
    
    let filmListScreen = UIIdentifiers.FilmListScreen.self
    let filmDetailScreen = UIIdentifiers.FilmDetailScreen.self
    let favoritesScreen = UIIdentifiers.FavoritesScreen.self
    let settingsScreen = UIIdentifiers.SettingsScreen.self
    let searchScreen = UIIdentifiers.SearchScreen.self
    
    var app: XCUIApplication!
    
    override func setUp() async throws {
        continueAfterFailure = false
        
        app = await XCUIApplication()
        await app.launch()
    }
    
    override func tearDown() async throws {
        app = nil
    }
    
    func testFilmListDisplaysFilms() throws {
        let filmList = app.collectionViews[filmListScreen.filmList].firstMatch
        XCTAssertTrue(filmList.waitForExistence(timeout: 3), "Film list not visible")
        
        let filmID = filmListScreen.item(nil)
        let predicate = NSPredicate(format: "identifier CONTAINS '\(filmID)'")
        let films = app.buttons.matching(predicate)
        
        XCTAssertGreaterThan(films.count, 2, "Should display multiple films")
    }
    
    func testFilmDetailNavigationAndShowingContent() throws {
        let filmID = "58611129-2dbc-4a81-a72f-77ddfc1b1b49"
        app.buttons[filmListScreen.item(filmID)].tap()
        
        let scrollView = app.scrollViews[filmDetailScreen.scrollView]
        XCTAssertTrue(scrollView.waitForExistence(timeout: 1), "Detail screen not shown")
        
        let title = app.staticTexts["My Neighbor Totoro"].firstMatch
        XCTAssertTrue(title.waitForExistence(timeout: 1), "Film title missing")
        
        let directorLabel = app.staticTexts["Director"].firstMatch
        let directorValue = app.staticTexts["Hayao Miyazaki"].firstMatch
        XCTAssertTrue(directorLabel.exists && directorValue.exists, "Director info missing")
        
        scrollView.swipeUp()
        let characterSection = app.otherElements[filmDetailScreen.characterSection].firstMatch
        XCTAssertTrue(characterSection.waitForExistence(timeout: 1), "Characters not visible")
        
        let firstCharacter = app.staticTexts["Satsuki Kusakabe"].firstMatch
        XCTAssertTrue(firstCharacter.exists, "Character data not loaded")
    }
    
    func testFilmListToggleFavorite() throws {
        // --- GIVEN ---
        let filmID = "2baf70d1-42bb-4437-b551-e5fed5a87abe"
        let film = app.buttons[filmListScreen.item(filmID)].firstMatch
        
        let favoriteButton = film.buttons[UIIdentifiers.favoriteButton].firstMatch
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 2), "Favorite button missing")
        
        let initialValue = favoriteButton.value as? String ?? ""
    
        // --- WHEN ---
        favoriteButton.tap()
        
        // --- THEN ---
        let afterToggleValue = favoriteButton.value as? String ?? ""
        let expectedNewValue = initialValue == "favorited" ? "not_favorited" : "favorited"
        XCTAssertEqual(afterToggleValue, expectedNewValue, "Should toggle favorite state")
        
        // --- WHEN ---
        favoriteButton.tap()
        
        // --- THEN ---
        let finalValue = favoriteButton.value as? String ?? ""
        XCTAssertEqual(finalValue, initialValue, "Should toggle back to inital state")
    }

    func testFilmDetailToggleFavorite() throws {
        // --- GIVEN ---
        let filmID = "2baf70d1-42bb-4437-b551-e5fed5a87abe"
        app.buttons[filmListScreen.item(filmID)].firstMatch.tap()
        
        let favoriteButton = app.buttons[UIIdentifiers.favoriteButton].firstMatch
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 1), "Favorite button missing")
        
        let initialValue = favoriteButton.value as? String ?? ""
        
        // --- WHEN ---
        favoriteButton.tap()
        
        // --- THEN ---
        let afterToggleValue = favoriteButton.value as? String ?? ""
        let expectedNewValue = initialValue == "favorited" ? "not_favorited" : "favorited"
        XCTAssertEqual(afterToggleValue, expectedNewValue, "Should toggle favorite state")
        
        // --- WHEN ---
        favoriteButton.tap()
        
        // --- THEN ---
        let finalValue = favoriteButton.value as? String ?? ""
        XCTAssertEqual(finalValue, initialValue, "Should toggle back to inital state")
    }
    
    func testRemoveFavoriteFilmCheckCount() throws {
        // --- GIVEN ---
        let favoritesTab = app.buttons[favoritesScreen.favoritesTab].firstMatch
        XCTAssertTrue(favoritesTab.waitForExistence(timeout: 3), "Should see favorites tab")
        favoritesTab.tap()
        
        let favoritesList = app.collectionViews[filmListScreen.filmList].firstMatch
        XCTAssertTrue(favoritesList.waitForExistence(timeout: 2), "Favorites list not visible")
        
        let initialCount = favoritesList.cells.count
        XCTAssertGreaterThan(initialCount, 0, "Need at least one favorite to remove")
        
        let firstFilmRow = favoritesList.cells.element(boundBy: 0)
        
        let favoriteButton = firstFilmRow.buttons[UIIdentifiers.favoriteButton].firstMatch
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 1), "Favorite button missing")
        
        // --- WHEN ---
        favoriteButton.tap()
        
        // --- THEN ---
        let finalCount = favoritesList.cells.count
        XCTAssertEqual(initialCount - 1, finalCount, "Expected \(initialCount - 1), got \(finalCount)")
    }
    
    func testRemoveAllFavorites() throws {
        // --- GIVEN ---
        let favoritesTab = app.buttons[favoritesScreen.favoritesTab].firstMatch
        XCTAssertTrue(favoritesTab.waitForExistence(timeout: 3), "Should see favorites tab")
        favoritesTab.tap()
        
        let favoritesList = app.collectionViews[filmListScreen.filmList].firstMatch
        XCTAssertTrue(favoritesList.waitForExistence(timeout: 2), "Favorites list not visible")
        
        let initialFilms = favoritesList.cells
        let initialCount = initialFilms.count
        XCTAssertGreaterThan(initialCount, 0, "Need at least one favorite to remove")
        
        // --- WHEN ---
        while favoritesList.cells.count > 0 {
            let firstFilm = favoritesList.cells.element(boundBy: 0)
            let favoriteButton = firstFilm.buttons[UIIdentifiers.favoriteButton].firstMatch
            XCTAssertTrue(favoriteButton.waitForExistence(timeout: 1), "Favorite button missing")
            
            favoriteButton.tap()
        }
        
        // --- THEN ---
        let finalCount = favoritesList.cells.count
        XCTAssertEqual(finalCount, 0, "Expected 0 films, got \(finalCount)")
        
        let contentUnavailableView = app.staticTexts[favoritesScreen.contentUnavailableView].firstMatch
        XCTAssertTrue(contentUnavailableView.waitForExistence(timeout: 2), "Should see ContentUnavailableView")
    }
    
    func testSearchFilmByTitle() throws {
        // --- GIVEN ---
        let searchQuery = "spirit"
        let filmTitle = "Spirited Away"
        
        let searchTab = app.buttons[searchScreen.searchTab].firstMatch
        XCTAssertTrue(searchTab.waitForExistence(timeout: 3), "Should see search tab")
        searchTab.tap()
        
        let searchField = app.searchFields["Search"].firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 1), "Should see search field")
        
        // --- WHEN ---
        searchField.tap()
        searchField.typeText(searchQuery)
        
        let searchList = app.collectionViews[filmListScreen.filmList].firstMatch
        XCTAssertTrue(searchList.waitForExistence(timeout: 3), "Should see a list of films")
        
        XCTAssertGreaterThan(searchList.cells.count, 0, "Expected at least one search result")
        
        let firstFilm = searchList.cells.element(boundBy: 0)
        XCTAssertTrue(firstFilm.waitForExistence(timeout: 2))
        
        firstFilm.tap()
        
        // --- THEN ---
        let title = app.staticTexts[filmTitle].firstMatch
        XCTAssertTrue(title.waitForExistence(timeout: 1), "Film title missing")
    }
}
