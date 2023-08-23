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
}

class Pen: Tool {
    @Published var width: CGFloat = 5.0
    @Published var color: Color = .cyan
}

class Highlighter: Tool {
    @Published var width: CGFloat = 2.5
    @Published var color: Color = .yellow
}

class Eraser: Tool {
    @Published var width: CGFloat = 2.5
    @Published var color: Color = .primary
}

class Lasso: Tool {
    @Published var width: CGFloat = 3.0
    @Published var color: Color = .blue
}

enum ToolsList: String, CaseIterable {
    case pen = "Pen"
    case highlighter = "Highlighter"
    case eraser = "Eraser"
    case lasso = "Lasso"
    case scoll = "Scroll"
}

class CurrentNoteProperties: ObservableObject {
    
    private var pen = Pen()
    private var highlighter = Highlighter()
    private var eraser = Eraser()
    private var lasso = Lasso()
    
    var currentTool: ToolsList = .pen {
        didSet {
            switch currentTool {
            case .pen:
                toolProperties = pen
            case .highlighter:
                toolProperties = highlighter
            case .eraser:
                toolProperties = eraser
            case .lasso:
                toolProperties = lasso
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
            endLasso()
            self.newTool = newValue
        }
    }
    
    @Published var lines = [Line]()
    @Published var selectMenuPoint: CGPoint?
    var selectedLines: [Int] = [Int]()
    
    var draggingLasso: Bool?
    
    var selectMenuRect: CGRect? {
        guard canshowSelectMenu == true else { return CGRect(x: 0, y: 0, width: 0, height: 0) }
        return CGRect(x: (selectMenuPoint!.x - 30), y: (selectMenuPoint!.y - 30), width: 70, height: 50)
    }
    
    func endLasso() {
        if selectedLines.count >= 0 && selectMenuPoint != nil {
            lines.removeLast()
        }
        
        selectedLines.removeAll()
        draggingLasso = false
        selectMenuPoint = nil
    }
    
    var canshowSelectMenu: Bool {
        return currentTool == .lasso && selectMenuPoint != nil && selectedLines.count > 0
    }
}

