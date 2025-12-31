//
//  SearchScreen.swift
//  Ghibli
//
//  Created by Antonio Damjanović on 31.12.2025..
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var text: String = ""
    
    var body: some View {
        NavigationStack {
            Text("Search Screen")
                .searchable(text: $text)
        }
    }
}

#Preview {
    SearchScreen()
}
