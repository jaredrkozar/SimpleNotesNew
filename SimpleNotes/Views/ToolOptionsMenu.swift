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
            
//            Section(header: Text("Color")) {
//                ToolWidthView(range: 1.0..<20.0, step: 1.0, currentValue: $properties.toolProperties.width)
//            }
//            
            Section(header: Text("Color")) {
                ColorPickerCell(currentValue: $properties.toolProperties.color)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct ToolWidthView: View {
    @State var range: ClosedRange<CGFloat>
    @State var step: CGFloat
    @Binding var currentValue: CGFloat
    
    @State private var inputValue: String = "4"
    
    var body: some View {
        HStack {
            Text("Width")
                .bold()
                .font(.title2)
        }
    }
}
