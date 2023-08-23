//
//  Page.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/26/23.
//

import Swift
import PDFKit

class Page: UIView {
    var pageStyle: PageStyle
    var pageNumber: Int?

    init(frame: CGRect, pageStyle: PageStyle, pageNumber: Int) {
        
        self.pageStyle = pageStyle
        self.pageNumber = pageNumber
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
               context.translateBy(x: 0, y: rect.height)
               context.scaleBy(x: 1, y: -1)
        
                switch pageStyle {
                case .none:
                    UIColor(named: "themeColor")?.setFill()
                    context.fill(rect)
                case .grid(let gridWidth):
                    let path = UIBezierPath()
                    for y in 0 ... Int(rect.height/gridWidth) {
                        path.move(to: CGPoint(x: 0, y: CGFloat(y)*gridWidth))
                        path.addLine(to: CGPoint(x: rect.width, y: CGFloat(y)*gridWidth))
                    }
                    for x in 0 ... Int(rect.width/gridWidth) {
                        path.move(to: CGPoint(x: CGFloat(x)*gridWidth, y: 0))
                        path.addLine(to: CGPoint(x: CGFloat(x)*gridWidth, y: rect.height))
                    }
                    path.stroke(with: .color, alpha: 1.0)
                case .lines(lineWidth: let lineWidth):
                    let path = UIBezierPath()
                    for y in 0 ... Int(rect.height/lineWidth) {
                        path.move(to: CGPoint(x: 0, y: CGFloat(y)*lineWidth))
                        path.addLine(to: CGPoint(x: rect.width, y: CGFloat(y)*lineWidth))
                    }
                    path.stroke(with: .color, alpha: 1.0)
                case .pdfPage(let pdfPage):
                    pdfPage.draw(with: .artBox, to: context)
                }

               let path = UIBezierPath()
               path.lineWidth = 3.0
                      path.move(to: CGPoint(x: 0,y: self.bounds.minY))
                      path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
                      path.move(to: CGPoint(x: 0, y: 0))
                      path.addLine(to: CGPoint(x: 0, y: self.bounds.maxY))
                      path.move(to: CGPoint(x: self.bounds.maxX, y: 0))
                      path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
                      path.move(to: CGPoint(x: 0, y: 0))
                      path.addLine(to: CGPoint(x: self.bounds.maxX, y: 0))
                      UIColor.lightGray.setStroke()
                      path.stroke()
    }
    
}

enum PageStyle {
    case none
    case grid(gridWidth: Double)
    case lines(lineWidth: Double)
    case pdfPage(pdfPage: PDFPage)
}

struct Constants {
    public static var width: Double = 8.5 * 72.0
    public static var height: Double = 8.5 * 72.0
}
