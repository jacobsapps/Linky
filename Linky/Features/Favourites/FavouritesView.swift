//
//  FavouritesView.swift
//  Linky
//
//  Created by Jacob Bartlett on 22/01/2025.
//

import SwiftUI

struct FavouritesView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Label("Favourites", systemImage: "star")
                    .font(.largeTitle)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.yellow)
            .navigationBarTitle("Favourites")
        }
    }
}
