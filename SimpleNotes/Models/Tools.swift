//
//  Tools.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/29/23.
//

import Foundation
import SwiftUI

protocol Tool: ObservableObject {
    var width: Double { get set }
    var color: Color { get set }
    var opacity: Double { get set }
}

class Pen: Tool {
    @Published var width: Double = 3.0
    
    @Published var color: Color = .green
    
    @Published var opacity: Double = 1.0
}
