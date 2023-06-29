//
//  ContentView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            NoteListView()
                .tabItem {
                    Label("Notes", systemImage: "list.dash")
                }
            TagListView()
                .tabItem {
                    Label("Tags", systemImage: "tag")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
