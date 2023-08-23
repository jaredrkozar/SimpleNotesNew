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
        ToolOptionsMenuModifier(toolWidth: $properties.toolProperties.width, toolColor: $properties.toolProperties.color, isEraser: properties.currentTool == .eraser)
    }
}

struct ToolOptionsMenuModifier: View {
    
    @Binding var toolWidth: CGFloat
    @Binding var toolColor: Color
    @State var isEraser: Bool
    
    var body: some View {
        
        List {
            Section(header: Text("Width")) {
                CustomSlider(options:  [2.5, 5, 7.5, 10.0, 15, 20.0], selected: $toolWidth, color: $toolColor)
            }
            
            if isEraser == false {
                Section(header: Text("Color")) {
                    ColorPickerCell(currentValue: $toolColor)
                }
            }
           
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
