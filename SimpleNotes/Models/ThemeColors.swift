//
//  ThemeColors.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import Foundation
import SwiftUI

struct ThemeColors: Identifiable {
    var colorName: String
    var color: Color
    var id: Int
}

var colors: [ThemeColors] = [
    ThemeColors(colorName: "Fiery Red", color: Color.red, id: 1),
    ThemeColors(colorName: "Atomic Orange", color: Color.orange, id: 2),
    ThemeColors(colorName: "Mango Yellow", color: Color.yellow, id: 3),
    ThemeColors(colorName: "Grassy Green", color: Color.green, id: 4),
    ThemeColors(colorName: "Pastel Blue", color: Color.cyan, id: 5),
    ThemeColors(colorName: "Ocean Blue", color: Color.blue, id: 6),
]
