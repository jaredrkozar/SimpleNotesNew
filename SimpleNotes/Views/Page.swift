//
//  Page.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/26/23.
//

import SwiftUI
import PDFKit

struct Page: View {
    var pageStyle: PageStyle
    var pageNumber: Int?
    var gridWidth: Double = 30.0
    var body: some View {
        Path { path in
            for y in 0 ... Int(Constants.height/gridWidth) {
                path.move(to: CGPoint(x: 0, y: CGFloat(y)*gridWidth))
                path.addLine(to: CGPoint(x: Constants.width, y: CGFloat(y)*gridWidth))
            }
            for x in 0 ... Int(Constants.width/gridWidth) {
                path.move(to: CGPoint(x: CGFloat(x)*gridWidth, y: 0))
                path.addLine(to: CGPoint(x: CGFloat(x)*gridWidth, y: Constants
                    .height))
            }
        }
        .stroke(Color.gray, lineWidth: 2)
    }
    
}

enum PageStyle {
    case none
    case grid(gridWidth: Double)
    case dot(dotWidth: Double)
    case pdfPage(pdfPage: PDFPage)
}

struct Constants {
    public static var width: Double = 8.5 * 72.0
    public static var height: Double = 1000
}
