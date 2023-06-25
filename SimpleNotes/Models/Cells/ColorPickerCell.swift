//
//  ColorPickerCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

import SwiftUI

struct ColorPickerCell: View, SettingsItem {
    static func == (lhs: ColorPickerCell, rhs: ColorPickerCell) -> Bool {
        return true
    }
    
    @Binding var currentValue: Color
    @State var tappedAction: ((Color) -> Void)
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(colors) { color in
                    ColorCell(color: color, currentValue: $currentValue, tappedAction: tappedAction)
                }
            }
        }
        .frame(height: 150)
    }
}

private struct ColorCell: View {
    @State var color: ThemeColors
    @Binding var currentValue: Color
    @State var tappedAction: ((Color) -> Void)
    
    var body: some View {
        Button(action: {
            currentValue = color.color
            tappedAction(currentValue)
        }) {
            ZStack {
                VStack {
                    Circle()
                        .fill(color.color)
                        .frame(width: 30, height: 30)
                    
                    Text(color.colorName)
                        .frame(width: 80, height: 60)
                        .foregroundColor(Color.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
            .contentShape(Rectangle())
        }
        
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(color.color, lineWidth: currentValue.toHex() == color.color.toHex() ? 4.0 : 0.0)
        )
        .buttonStyle(BaseButtonStyle())
        
        .padding(10)
        
    }
}
