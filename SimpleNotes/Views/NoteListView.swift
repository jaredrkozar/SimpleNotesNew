//
//  NoteListView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct NoteListView: View {
    @State var currentTag: String?
    @FetchRequest(fetchRequest: Note.makeFetchRequest(), animation: .default) var notes: FetchedResults<Note>
    @Environment(\.managedObjectContext) var managedObjectContext
    
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
