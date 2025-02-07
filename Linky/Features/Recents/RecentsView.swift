//
//  RecentsView.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import SwiftUI

struct RecentsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Label("Recents", systemImage: "person.crop.circle.badge.clock.fill")
                    .font(.largeTitle)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green)
            .navigationBarTitle("Recents")
        }
    }
}

