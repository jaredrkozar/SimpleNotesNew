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
    
    var body: some View {
        NavigationStack {
            List(tags, id: \.self) { tag in
                Text(tag.tagName!)
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
            NewTagView()
                .presentationDetents([.medium, .large])
        }
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}
