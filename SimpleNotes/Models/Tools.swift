//
//  Tools.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/29/23.
//

import Foundation
import SwiftUI

protocol Tool: ObservableObject {
    var width: CGFloat { get set }
    var color: Color { get set }
    var points: [CGPoint] { get set }
}

class Pen: Tool {
    @Published var width: CGFloat = 4.0
    @Published var color: Color = .cyan
    @Published var points: [CGPoint] = [CGPoint]()
}

class Highlighter: Tool {
    @Published var width: CGFloat = 3.0
    
    @Published var color: Color = .yellow
    @Published var points: [CGPoint] = [CGPoint]()
}

class Eraser: Tool {
    @Published var width: CGFloat = 3.0
    
    @Published var color: Color = .primary
    @Published var points: [CGPoint] = [CGPoint]()
}

enum ToolsList: String, CaseIterable {
    case pen = "Pen"
    case highlighter = "Highlighter"
    case eraser = "Eraser"
}

class CurrentNoteProperties: ObservableObject {
    
    private var pen = Pen()
    private var highlighter = Highlighter()
    private var eraser = Eraser()
    
    var currentTool: ToolsList = .pen {
        didSet {
            switch currentTool {
            case .pen:
                toolProperties = pen
            case .highlighter:
                toolProperties = highlighter
            case .eraser:
                toolProperties = eraser
            default:
                toolProperties = pen
            }
        }
    }
    
    private var newTool: (any Tool)?
    
    var toolProperties: any Tool {
        get {
            return newTool ?? pen;
        }
        set {
            self.newTool = newValue
        }
    }
}

