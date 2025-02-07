//
//  AddContactView.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import SwiftUI

struct AddContactView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Label("Add Contact", systemImage: "person.badge.plus")
                    .font(.largeTitle)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
            .navigationBarTitle("Contacts")
        }
    }
}

