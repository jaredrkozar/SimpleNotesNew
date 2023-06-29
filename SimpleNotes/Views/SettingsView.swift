//
//  SettingsView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 6/28/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("Settings screen")
            }
            .navigationTitle("Notes")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
