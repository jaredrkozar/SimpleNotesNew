//
//  AddTagsToNoteView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/13/23.
//

import SwiftUI

struct AddTagsToNoteView: View {
    var note: Note
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.tagName)
        ]
    ) var allTags: FetchedResults<Tag>

    @Environment(\.managedObjectContext) var context
    
    
    var tagsNotInNote: [Tag] {
        let tagsInNote = note.tag?.allObjects as? [Tag]
        return allTags.filter({!tagsInNote!.contains($0)})
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                NoteTagDropView(tags: (note.tag?.allObjects as [Tag]), tappedTagAction: { tagToAddToNote in
                    print(tagToAddToNote.tagName)
                    note.removeFromTag(tagToAddToNote)
                    saveData(context: context)
                } , title: "Current Tags in \(note.title ?? "Untitled Note")", fillInTag: true)
                
                NoteTagDropView(tags: tagsNotInNote.reversed(), tappedTagAction: { tagToAddToNote in
                    print(tagToAddToNote.tagName)
                    note.addToTag(tagToAddToNote)
                    saveData(context: context)
                } , title: "Tags Not in Note", fillInTag: false)
            }
            .padding()
            .navigationTitle("Tags")
        }
    }
}
