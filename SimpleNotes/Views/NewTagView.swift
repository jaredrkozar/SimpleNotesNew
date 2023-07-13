//
//  NewTagView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct NewTagView: View {
    
    @StateObject private var tagProperties = CurrentTagProperties()
    @Binding var currentTag: Tag?
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
     
        NavigationView {
            VStack {
                TagChip(tagName: tagProperties.tagName, tagIcon: tagProperties.tagIconName, tagColor: tagProperties.tagColor, fillInTag: false)
                SettingsPage {
                    SettingsSectionView {
                        TextCell(currentValue: $tagProperties.tagName, placeholder: "Enter tag name", leftText: "Tag name")
                        LinkCell(title: "Select Icon", destination: SelectTagIconView(properties: tagProperties))
                        ColorPickerCell(currentValue: $tagProperties.tagColor, tappedAction: {_ in })
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                       Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        saveNewTag(properties: tagProperties, context: context, tag: currentTag)
                        dismiss()
                    }) {
                       Text("Save")
                    }
                    .disabled(tagProperties.tagName.isEmpty)
                }
            }
            .accentColor(tagProperties.tagColor)
        }
        .onAppear {
            if currentTag != nil {
                tagProperties.tagColor = Color(hex: (currentTag?.color)!)!
                tagProperties.tagName = currentTag!.tagName!
                tagProperties.tagIconName = currentTag!.symbolName!
            }
        }
    }
}

struct NewView: View {
    var body: some View {
        HStack {
            Text("D<D<D<<D<D<D")
        }
    }
}

class CurrentTagProperties: ObservableObject {
    //not saving because im not alerting the tag directly...need to change this
    @Published var tagName: String = ""
    @Published var tagColor: Color = .red
    @Published var tagIconName: String = "mic"
}
