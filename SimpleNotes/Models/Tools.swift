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
    @Published var width: CGFloat = 5.0
    @Published var color: Color = .cyan
    @Published var points: [CGPoint] = [CGPoint]()
}

class Highlighter: Tool {
    @Published var width: CGFloat = 2.5
    
    @Published var color: Color = .yellow
    @Published var points: [CGPoint] = [CGPoint]()
}

class Eraser: Tool {
    @Published var width: CGFloat = 2.5
    
    @Published var color: Color = .primary
    @Published var points: [CGPoint] = [CGPoint]()
}

class Lasso: Tool {
    @Published var width: CGFloat = 3.0
    
    @Published var color: Color = .blue
    @Published var points: [CGPoint] = [CGPoint]()
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
            removeLasso = true
            endLasso()
            self.newTool = newValue
        }
    }
    
    @Published var selectMenuPoint: CGPoint?
    var selectedLines: [Int] = [Int]()
    
    var removeLasso: Bool?
    var selectMinX: CGFloat?
    var selectMaxX: CGFloat?
    var selectMinY: CGFloat?
    
    var selectMenuRect: CGRect? {
        guard canshowSelectMenu == true else { return CGRect(x: 0, y: 0, width: 0, height: 0) }
        return CGRect(x: (selectMenuPoint!.x), y: (selectMenuPoint!.y), width: 150, height: 100)
    }
    
    func endLasso() {
        removeLasso = false
        selectMenuPoint = nil
        selectMinX = nil
        selectMinX = nil
        selectMaxX = nil
        selectedLines.removeAll()
    }
    
    var canshowSelectMenu: Bool {
        return currentTool == .lasso && selectMenuPoint != nil && selectedLines.count > 1
    }
}

