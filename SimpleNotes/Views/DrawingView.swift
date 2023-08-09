//
//  DrawingView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/29/23.
//

import Foundation
import SwiftUI

struct DrawingView: View {
    @State private var lines: [Line] = [Line]()
    @State private var interactedLines: [Line] = [Line]()
    
    @ObservedObject var properties: CurrentNoteProperties
    
    @State var selectMinX: CGFloat?
    @State var selectMaxX: CGFloat?
    @State var selectMinY: CGFloat?
    @State var selectMaxY: CGFloat?
    
    @State var lassoElements: [Int]?
    
    var body: some View {
        ZStack {
            if properties.currentTool == .lasso && properties.showSelectionMenu == true && selectMaxX != nil {
                Rectangle()
                    .foregroundColor(.green)
                    .frame(width: 100, height: 30)
                    .position(x: (selectMinX! + selectMaxX!) / 2, y: selectMinY!)
            }
            
            
            Canvas { context, size in
                guard lines.count > 0 else { return }
                let line = lines.last
                context.stroke(line!.path, with: .color(.green), style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
            }
        }
        
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    if properties.currentTool != .scoll {
                        if value.translation == .zero {
                            //length of line is zero -> new line
                            if properties.currentTool == .lasso {
                                properties.showSelectionMenu = false
                                endSelectRect()
                            }
                            
                            lines.append(Line(color: properties.toolProperties.color, width: properties.toolProperties.width, opacity: properties.currentTool != .highlighter ? 1.0 : 0.6, points: [value.location]))
                        } else {
                            guard let lastIndex = lines.indices.last else { return }
                            print("")
                            lines[lastIndex].points.append(value.location)

                            if properties.currentTool == .eraser {

                                interactedLines = self.linesThatIntersect(with: lines.last!)
                                
                            } else if properties.currentTool == .lasso {
                                updateSelectRect(value.location)
                            }
                    }

                    }})
                .onEnded({ value in
                    if properties.currentTool == .eraser {
                        lines.removeLast()
                        lines = lines.filter { !interactedLines.contains($0) }
                    } else if properties.currentTool == .lasso {

                        properties.showSelectionMenu = true
                        if properties.currentTool == .lasso {
                            lines[lines.count - 1].points.append(value.startLocation)
                        }
                        
                        for line in lines.indices {
                            if lines[lines.count - 1].lassoContainsLine(line: lines[line]) {
                                lassoElements?.append(line)
                                lines[line].updateOpacity()
                            }
                        }
                    }
                    
                })
        )
    }
    
    func linesThatIntersect(with line: Line) -> [Line] {
        return self.lines.filter({$0.intersects(line: line)})
    }
    
    private func updateSelectRect(_ translatedPoint: CGPoint) {
        guard translatedPoint.x != 0.0 else { return }
        guard translatedPoint.y != 0.0 else { return }
        guard let selectMinX = selectMinX,
              let selectMaxX = selectMaxX,
              let selectMinY = selectMinY,
              let selectMaxY = selectMaxY else {
            selectMinX = translatedPoint.x
            selectMaxX = translatedPoint.x
            selectMinY = translatedPoint.y
            selectMaxY = translatedPoint.y
            return
        }
        
        self.selectMinX = min(selectMinX, translatedPoint.x)
        self.selectMaxX = max(selectMaxX, translatedPoint.x)
        self.selectMinY = min(selectMinY, translatedPoint.y)
        self.selectMaxY = max(selectMaxY, translatedPoint.y)
    }
    
    private func endSelectRect() {
        selectMinX = nil
        selectMaxX = nil
        selectMinY = nil
        selectMaxY = nil
    }
}

struct Line: Equatable {
    var color: Color
    var width: CGFloat
    var opacity: Double
    var points: [CGPoint] = [CGPoint]()
    
    
    var path: Path {
        var path = Path()
        
        if let firstPoint = points.first {
            path.move(to: firstPoint)
        }
        
        for index in 1..<points.count {
            let mid = midPoint(point1: points[index - 1], point2: points[index])
            path.addQuadCurve(to: mid, control: points[index - 1])
        }
        
        if let last = points.last {
            path.addLine(to: last)
        }
        
        return path
    }
    
    mutating func updateOpacity() {
        self.opacity = 0.6
    }
    
    func lassoContainsLine(line: Line) -> Bool{
         return line.points.contains(where: {self.containsPoint(test: $0)})
     }
    
    func containsPoint(test: CGPoint) -> Bool {
        let polygon = self.points
        let count = polygon.count
        var j = 0
        var contains = false
        
        for i in 0 ..< count - 1
        {
            j = i + 1
            if ( ((polygon[i].y >= test.y) != (polygon[j].y >= test.y)) &&
                (test.x <= (polygon[j].x - polygon[i].x) * (test.y - polygon[i].y) /
                    (polygon[j].y - polygon[i].y) + polygon[i].x) ) {
                contains = !contains;
            }
        }
        return contains;
    }
    
    func intersects(line: Line) -> Bool{
        for counter in 1 ..< self.points.count{
            for tracker in 1 ..< line.points.count{
                if (doIntersect(self.points[counter - 1], self.points[counter], line.points[tracker - 1], line.points[tracker])){
                    return true
                }
            }
        }
        return false
    }
    
    //Check if the two lines intersect, given their endpoints
    private func doIntersect(_ p1: CGPoint, _ q1: CGPoint, _ p2: CGPoint, _ q2: CGPoint) -> Bool
    {
        let o1 = orientation(p1, q1, p2)
        let o2 = orientation(p1, q1, q2)
        let o3 = orientation(p2, q2, p1)
        let o4 = orientation(p2, q2, q1)
        if (o1 != o2 && o3 != o4){return true}
        if (o1 == 0 && onSegment(p1, q2, q1)){return true}
        if (o2 == 0 && onSegment(p1, q2, q1)){return true}
        if (o3 == 0 && onSegment(p2, p1, q2)){return true}
        if (o4 == 0 && onSegment(p2, q1, q2)){return true}
        return false
    }
    
    //Checks the direction of the three points
    private func orientation(_ p: CGPoint, _ q: CGPoint, _ r: CGPoint) -> Int
    {
        let value = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
        if (value == 0) {return 0}
        return value > 0 ? 1: 2
    }
    
    //Checks if the point is on the segment
    private func onSegment(_ p1: CGPoint, _ p2: CGPoint, _ q1: CGPoint) -> Bool
    {
        return p2.x <= max(p1.x, q1.x) && p2.x >= min(p1.x, q1.x) && p2.y <= max(p1.y, q1.y) && p2.y > min(p1.y, q1.y)
    }
    
    mutating func translate(vector: CGVector) {
        points = points.map({$0.moveBy(x: vector.dx, y: vector.dy)})
        path.applying(CGAffineTransform(translationX: vector.dx, y: vector.dy))
    }
    
    func midPoint(point1: CGPoint, point2: CGPoint) -> CGPoint {
        //gets the midpoints of the two specified points
        let x=(point1.x+point2.x)/2
        let y=(point1.y+point2.y)/2
        return CGPoint(x: x, y: y)
    }
    
}

//
//  Extensions.swift
//  SamplePDFDrawingViewApp
//
//  Created by Jack Rosen on 4/5/19.
//  Copyright © 2019 Jack Rosen. All rights reserved.
//

public extension CGPoint{
    // Returns a new point with the different subtracted
    func subtract(point: CGPoint) -> CGPoint{
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
    
    // Scales a point
    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    // Creates a line of points between this and the other point
    func addIncrements(amount: Int, until point: CGPoint) -> [CGPoint]
    {
        var array = [CGPoint]()
        let xDistance = (point.x - self.x) / CGFloat(amount)
        let yDistance = (point.y - self.y) / CGFloat(amount)
        let movementVector = CGVector(dx: xDistance, dy: yDistance)
        for counter in 1 ..< amount
        {
            array.append(self + movementVector * CGFloat(counter + 1))
        }
        return array
    }
    static func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint{
        return CGPoint(x: 0, y: lhs.y / rhs)
    }
    static func + (lhs: CGPoint, rhs: CGFloat) -> CGPoint{
        return CGPoint(x: lhs.x, y: lhs.y + rhs)
    }
    
    // Gets the midpoint between two points
    func midPoint(with point: CGPoint) -> CGPoint
    {
        return CGPoint(x: (self.x + point.x) / 2, y: (self.y + point.y) / 2)
    }
    
    // Moves the point
    func moveBy(x: CGFloat, y: CGFloat) -> CGPoint
    {
        return self + CGVector(dx: x, dy: y)
    }
    
    // Shifts up the point
    func shiftUpBy(_ angle: Double, _ offsetAmount: Double) -> CGPoint {
        return CGPoint(x: Double(self.x) + sin(angle) * offsetAmount, y: Double(self.y) + cos(angle) * offsetAmount)
    }
    
    // Shifts down the point
    func shiftDownBy(_ angle: Double, _ offsetAmount: Double) -> CGPoint {
        return CGPoint(x: Double(self.x) - sin(angle) * offsetAmount, y: Double(self.y) - cos(angle) * offsetAmount)
    }
    
    // Distance between two points
    func distance(to point: CGPoint) -> CGVector{
        return CGVector(dx: point.x - self.x, dy: point.y - self.y)
    }
    
    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint{
        return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    static func - (lhs: CGPoint, rhs: CGVector) -> CGPoint{
        return CGPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }
}

public extension UITextView{
    // Moves the text view
    func moveBy(x: CGFloat, y: CGFloat)
    {
        self.frame.origin = CGPoint(x: self.frame.origin.x + x, y: self.frame.origin.y + y)
    }
}

public extension Int{
    func toString() -> String{
        return "\(self)"
    }
}

extension CGRect{
    static func *= (lhs: inout CGRect, rhs: CGFloat){
        lhs = CGRect(x: lhs.origin.x, y: lhs.origin.y, width: lhs.width * rhs, height: lhs.height * rhs)
    }
    static func / (lhs: CGRect, rhs: CGFloat) -> CGRect{
        return CGRect(x: lhs.origin.x, y: lhs.origin.y, width: lhs.width / rhs, height: lhs.height / rhs)
    }
}

extension CGVector{
    func normalized() -> CGVector{
        let y = self.dy == 0 ? 0 : -self.dy
        return CGVector(dx: y, dy: self.dx)
    }
    func unitize() -> CGVector{
        var distance = sqrt(Double((self.dx * self.dx) + (self.dy * self.dy)))
        if distance == 0{
            distance = 1
        }
        return CGVector(dx: self.dx / CGFloat(distance), dy: self.dy / CGFloat(distance))
    }
    static func * (lhs: CGVector, rhs: CGFloat) -> CGVector{
        return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }
}


extension Double{
    func abs() -> Double{
        return Swift.abs(self)
    }
}
