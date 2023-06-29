//
//  NewTagView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct NewTagView: View {
    
    @StateObject private var tagProperties = CurrentTagProperties()
    @State var currentTag: Tag?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
     
        NavigationView {
            SettingsPage {
                SettingsSectionView {
                    TextCell(currentValue: $tagProperties.tagName, placeholder: "Enter tag name", leftText: "Tag name")
                    LinkCell(title: "Select Icon", destination: SelectTagIconView(properties: tagProperties))
                    ColorPickerCell(currentValue: $tagProperties.tagColor, tappedAction: {_ in })
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
                        currentTag != nil ? currentTag?.saveExistingTag(properties: tagProperties) : saveNewTag(properties: tagProperties)
                        dismiss()
                    }) {
                       Text("Save")
                    }
                }
            }
            .accentColor(tagProperties.tagColor)
        }
        .onAppear {
            print(currentTag)
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
    @Published var tagName: String = ""
    @Published var tagColor: Color = .red
    @Published var tagIconName: String = "mic"
}
