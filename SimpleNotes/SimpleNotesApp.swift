//
//  SimpleNotesApp.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

@main
struct SimpleNotesApp: App {
    @StateObject private var dataController = CoreDataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.context)
            
        }
    }
}
