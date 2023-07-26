//
//  NoteListView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct NoteListView: View {
    @State var currentTag: String?
    @State private var selectedNote: Note?
    @State private var showTagSheet: Bool = false
    @State private var scope = SearchScope()
    
    @FetchRequest(sortDescriptors: []) private var notes: FetchedResults<Note>
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    var body: some View {
       NavigationStack {
           Group {
               if !scope.tag.isEmpty && notes.count == 0 {
                   noNotesForTag
               } else if scope.tag.isEmpty && notes.count == 0 {
                   noNotes
               } else {
                   List(notes, id: \.self) { note in
                       NoteCell(note: note)
                           .swipeActions(edge: .leading) {
                               Button {
                                    selectedNote = note
                                   showTagSheet.toggle()
                               } label: {
                                   Label("Edit Tag", systemImage: "tag")
                               }
                               
                                 .tint(.blue)
                             }
                   }
               }
           }

           .sheet(isPresented: $showTagSheet) {
               AddTagsToNoteView(note: selectedNote ?? notes[0])
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
       .onAppear {
           scope.tag = currentTag ?? ""
       }
        
       .onChange(of: scope) { newValue in
           notes.nsPredicate = NSPredicate(format:  "tag.tagName CONTAINS[c] %@", scope.tag)
       }
    }
    
    var noNotes: some View {
        VStack {
            Image(systemName: "rectangle.portrait.slash")
                .font(.title3)
            
            Text("You haven't created any notes yet")
                .bold()
                .font(.title)
                .foregroundColor(.gray)
            
            Text("Tap the plus button in the upper right t create a new note")
                .font(.title3)
                .foregroundColor(.gray)
        }
        .multilineTextAlignment(.center)
    }
    
    var noNotesForTag: some View {
        VStack {
            Image(systemName: "tag.slash")
                .font(.title3)
            
            Text("There are no notes with the specified tag")
                .bold()
                .font(.title)
                .foregroundColor(.gray)
            
            Text("Select another tag or add this tag to a note to have the note show up here")
                .font(.title3)
                .foregroundColor(.gray)
        }
        .multilineTextAlignment(.center)
    }
}

struct SearchScope: Equatable {
  var tag: String = ""
}
