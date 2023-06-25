//
//  ThemeColors.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import Foundation
import SwiftUI

enum ThemeColors: Int, CaseIterable, Identifiable {
    var id: Self { self }
    
    case red
    case orange
    case yellow
    case green
    case lightBlue
    case darkBlue
    
    var tintColor: Color {
        switch self {
            case .red:
                return Color.red
            case .orange:
                return Color.orange
            case .yellow:
                return Color.yellow
            case .green:
                return Color.green
            case .lightBlue:
                return Color.cyan
            case .darkBlue:
                return Color.blue
        }
    }
    
    var themeName: String {
        switch self {
            case .red:
                return "Fiery Red"
            case .orange:
                return "Atomic Orange"
            case .yellow:
                return "Mango Yellow"
            case .green:
                return "Grassy Green"
            case .lightBlue:
                return "Pastel Blue"
            case .darkBlue:
                return "Ocean Blue"
        }
    }
}
