//
//  ContactsView.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import SwiftUI

struct ContactsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Label("Contacts", systemImage: "person.3.sequence")
                    .font(.largeTitle)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
            .navigationBarTitle("Contacts")
        }
    }
}

