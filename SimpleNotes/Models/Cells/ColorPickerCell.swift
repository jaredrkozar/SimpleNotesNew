//
//  ColorPickerCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/4/23.
//

import SwiftUI

struct ColorPickerCell: View {
    @Binding var currentValue: Color
        
    let columns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    @State private var colors: [Color] = [ Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.cyan, Color.purple, Color.indigo, Color.pink, Color.brown,  Color.gray, Color.black
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40), alignment: .top)]) {
                
                ForEach(colors, id: \.description) { color in
                    Button {
                        currentValue = color
                    } label: {
                        Circle()
                            .fill(color)
                            .overlay {
                                Image(systemName: "checkmark.circle")
                                    .tint(color == currentValue ? .white : color)
                            }
                    }
                }
            }
        }
    }
}

class UIColorWellHelper: NSObject {
    static let helper = UIColorWellHelper()
    var execute: (() -> ())?
    @objc func handler(_ sender: Any) {
        execute?()
    }
}
