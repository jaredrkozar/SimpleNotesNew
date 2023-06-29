//
//  TagListView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct TagListView: View {
    @State private var showingNewTagSheet = false
    @FetchRequest(fetchRequest: Tag.makeFetchRequest(), animation: .default) var tags: FetchedResults<Tag>
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var selectedTag: Tag?
    
    var body: some View {
        NavigationStack {
            List(tags, id: \.self) { tag in
                NavigationLink {
                    NoteListView(currentTag: tag.tagName)
                } label: {
                    TagCell(tag: tag)
                        .swipeActions(edge: .leading) {
                             Button {
                                selectedTag = tag
                                 showingNewTagSheet.toggle()
                            } label: {
                                Label("Edit Tag", systemImage: "tag")
                            }
                            
                              .tint(.blue)
                          }
                        .swipeActions(edge: .trailing) {
                             Button {
                                 tag.deleteTag()
                            } label: {
                                Label("Delete Tag", systemImage: "trash")
                            }
                            
                              .tint(.red)
                          }
                }
            }

            .listStyle(.insetGrouped)

            .navigationTitle("Tags")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showingNewTagSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        
        .sheet(isPresented: $showingNewTagSheet) {
            NewTagView(currentTag: selectedTag)
                .presentationDetents([.medium, .large])
        }
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}

struct TagCell: View {
    var tag: Tag
    
    var body: some View {
        HStack {
            Image(systemName: tag.symbolName!)
                .foregroundColor(Color(hex: tag.color!))
            
            Text(tag.tagName!)
        }
    }
}
