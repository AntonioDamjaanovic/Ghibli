//
//  FilmImageView.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 30.12.2025..
//

import SwiftUI

struct FilmImageView: View {
    
    let url: URL?
    
    init(url: String) {
        self.url = URL(string: url)
    }
    
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
                case .empty:
                Color(white: 0.8)
                    .overlay {
                        ProgressView()
                            .controlSize(.large)
                    }
                    
                case .success(let image):
                    image
                    .resizable()
                    .scaledToFill()
                    
                case .failure(_):
                    Text("Could not get an image")
                
                @unknown default:
                    fatalError()
            }
        }
    }
}

#Preview("Poster Image") {
    
    let url = URL.convertAssetImage(named: "posterImage")
    
    //FilmImageView(url: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/npOnzAbLh6VOIu3naU5QaEcTepo.jpg")
    
    FilmImageView(url: url)
        .frame(height: 150)
}

#Preview("Banner Image") {
    
    let url = URL.convertAssetImage(named: "bannerImage")
    
    //FilmImageView(url: "https://image.tmdb.org/t/p/w533_and_h300_bestv2/3cyjYtLWCBE1uvWINHFsFnE8LUK.jpg")
    
    FilmImageView(url: url)
        .frame(height: 300)
}
