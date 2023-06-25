//
//  NewTagView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct NewTagView: View {
    @AppStorage("tagtTintColor") var tagtTintColor: Int = 1
    
    @State var tagName: String = ""
    @State var selectedIconName: String = "folder"
    @State var tagColor: Int = 1
    
    @Environment(\.tintColor) var tintColor
    var body: some View {
     
        NavigationView {
            SettingsPage {
                SettingsSectionView {
                    TextCell(currentValue: $tagName, placeholder: "Enter tag name", leftText: "Tag name")
                    LinkCell(title: "Select Icon", destination: SelectTagIconView(selectedIconName: $selectedIconName, iconColor: ThemeColors(rawValue: tagColor)!.tintColor))
                    ColorPickerCell(currentValue: $tagColor, tappedAction: {_ in })
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
                       saveNewTag(name: tagName, symbol: selectedIconName, color: tagColor)
                    }) {
                       Text("Save")
                    }
                }
            }
            .accentColor(ThemeColors(rawValue: tagColor)?.tintColor)
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
