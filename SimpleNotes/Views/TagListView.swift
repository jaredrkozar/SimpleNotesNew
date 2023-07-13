//
//  TagListView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct TagListView: View {
    @State private var showingDeleteTagAlert = false
    @State private var showingNewTagSheet = false
    @FetchRequest(fetchRequest: Tag.makeFetchRequest(), animation: .default) var tags: FetchedResults<Tag>
    @Environment(\.managedObjectContext) var context
    @State private var selectedTag: Tag?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                FlowLayout(tags, spacing: 9) { tag in
                Button(action: {
                    print(tag.tagName)
                }, label: {
                    TagChip(tagName: tag.tagName!, tagIcon: tag.symbolName!, tagColor: Color(hex: tag.color!)!, fillInTag: false)
                        .contextMenu {
                            Button(role: .none) {
                              selectedTag = tag
                                showingNewTagSheet = true
                            } label: {
                              Label("Edit Tag", systemImage: "tag")
                            }
                            
                            Button(role: .destructive) {
                              selectedTag = tag
                                showingDeleteTagAlert = true
                            } label: {
                              Label("Delete Tag", systemImage: "trash")
                            }
                        }
                })
              }
              .padding()
            }

            .navigationTitle("Tags")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        selectedTag = nil
                        showingNewTagSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        
        .sheet(isPresented: $showingNewTagSheet) {
            NewTagView(currentTag: $selectedTag)
                .presentationDetents([.medium, .large])
        }
                                    
        .alert(isPresented: $showingDeleteTagAlert) { () -> Alert in
            let primaryButton = Alert.Button.destructive(Text("Delete Tag")) {
                selectedTag?.deleteTag(context: context)
            }
            let secondaryButton = Alert.Button.cancel(Text("Keep Note")) {
                return
            }
            return Alert(title: Text("Are you sure you want to delete this tag?"), message: Text("All of your notes with this tag will still be kept and not deleted from your device"), primaryButton: primaryButton, secondaryButton: secondaryButton)
        }
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}

struct TagCell: View {
    @ObservedObject var tag: Tag
    
    var body: some View {
        HStack {
            if tag.tagName != nil {
                Image(systemName: tag.symbolName!)
                    .foregroundColor(Color(hex: tag.color!))
                
                Text(tag.tagName!)
            }
        }
    }
}
