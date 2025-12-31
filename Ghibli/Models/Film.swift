//
//  Film.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 28.12.2025..
//

import Foundation

struct Film: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let description: String
    let director: String
    let producer: String
    let releaseYear: String
    let score: String
    let duration: String
    let image: String
    let bannerImage: String
    let people: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, title, image, description, director, producer, people
        
        case bannerImage = "movie_banner"
        case releaseYear = "release_date"
        case duration = "running_time"
        case score = "rt_score"
    }
    
    // MARK: Preview
    static var example: Film {
        //MockGhibliService().fetchFilm()
        let bannerURL = URL.convertAssetImage(named: "bannerImage")
        let posterURL = URL.convertAssetImage(named: "posterImage")
        
        return Film(
            id: "id",
            title: "My Neighbor Totoro",
            description: "Two sisters move to the country with their father in order to be closer to their hospitalized mother, and discover the surrounding trees are inhabited by Totoros, magical spirits of the forest. When the youngest runs away from home, the older sister seeks help from the spirits to find her.",
            director: "Hayao Miyazaki",
            producer: "Hayao Miyazaki",
            releaseYear: "1988",
            score: "93",
            duration: "86",
            image: posterURL?.absoluteString ?? "",
            bannerImage: bannerURL?.absoluteString ?? "",
            people: ["https://ghibliapi.vercel.app/people/598f7048-74ff-41e0-92ef-87dc1ad980a9"]
        )
    }
}

import Playgrounds

#Playground {
    let url = URL(string: "https://ghibliapi.vercel.app/films")!
    
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try JSONDecoder().decode([Film].self, from: data)
    } catch {
        print(error)
    }
}
