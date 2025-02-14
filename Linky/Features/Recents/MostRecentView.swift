//
//  MostRecentView.swift
//  Linky
//
//  Created by Jacob Bartlett on 07/02/2025.
//

import SwiftUI

struct MostRecentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Label("Most Recent", systemImage: "clock.fill")
                    .font(.largeTitle)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green)
            .navigationBarTitle("Most Recent")
        }
    }
}
