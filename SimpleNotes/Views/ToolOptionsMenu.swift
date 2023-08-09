//
//  ToolOptionsMenu.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/30/23.
//

import Foundation
import SwiftUI

struct ToolOptionsMenu: View {
    
    @ObservedObject var properties: CurrentNoteProperties

    var body: some View {
        
        List {
            Section(header: Text("Width")) {
                CustomSlider(options:  [2.5, 5, 7.5, 10.0, 15, 20.0], selected: $properties.toolProperties.width, color: $properties.toolProperties.color)
            }
            
            if properties.currentTool != .eraser {
                Section(header: Text("Color")) {
                    ColorPickerCell(currentValue: $properties.toolProperties.color)
                }
            }
           
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
