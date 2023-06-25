//
//  NewTagView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct NewTagView: View {
    
    @StateObject var tagProperties = CurrentTagProperties()
    
    @Environment(\.tintColor) var tintColor
    var body: some View {
     
        NavigationView {
            SettingsPage {
                SettingsSectionView {
                    TextCell(currentValue: $tagProperties.tagName, placeholder: "Enter tag name", leftText: "Tag name")
                    LinkCell(title: "Select Icon", destination: SelectTagIconView(properties: tagProperties))
                    ColorPickerCell(currentValue: $tagProperties.color.color, tappedAction: {_ in })
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Cancel")
                    }) {
                       Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                    print("DLDL")
                    }) {
                       Text("Save")
                    }
                }
            }
            .accentColor(tagProperties.color.color)
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
    @Published var color: ThemeColors = colors.first!
    @Published var iconName: String = "mic"
}
