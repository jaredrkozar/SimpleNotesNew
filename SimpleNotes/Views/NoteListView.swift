//
//  NoteListView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct NoteListView: View {
    @State private var currentTag: String?
    var request: FetchRequest<Note>
    var notes: FetchedResults<Note>{ request.wrappedValue }
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    init(currentTag: String? = nil) {
        var predicate: NSPredicate? = nil
        if currentTag != nil {
            predicate = NSPredicate(format: "tag.tagName CONTAINS[c] %@", currentTag!)
        }
        self.request = FetchRequest<Note>(sortDescriptors: [], predicate: predicate)
    }
    
    var body: some View {
       NavigationStack {
           List(notes, id: \.self) { note in
               Text("note.title!")

           }

           .listStyle(.insetGrouped)

           .navigationTitle("Notes")
           .toolbar {
               ToolbarItem(placement: .automatic) {
                   Button {
                       let newNote = Note(context: managedObjectContext)
                       newNote.title = "title"
                       newNote.data = Data()

                       do {
                         try managedObjectContext.save()
                           print("DLD")
                       } catch {
                         print("An error occured while saving the preset.")
                       }
                   } label: {
                       Image(systemName: "plus")
                   }
               }
           }
       }
    }
}
