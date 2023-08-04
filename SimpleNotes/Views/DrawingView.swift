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
    
    @State private var pointsForLine = [CGPoint]()
    @State private var previousPoint: CGPoint = CGPoint()
    @State private var previousPreviousPoint: CGPoint = CGPoint()
    @ObservedObject var properties: CurrentNoteProperties
    
    var body: some View {
        Canvas { context, size in
            for line in lines {
                context.opacity = line.opacity
                var path = Path()
                
                path = smoothCurveFromPoints(line.points)

                context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    self.pointsForLine.append(value.location)
                    
                    if value.translation == .zero {
                        //length of line is zero -> new line
                        lines.append(Line(color: properties.toolProperties.color, width: properties.toolProperties.width, opacity: properties.currentTool != .highlighter ? 1.0 : 0.6, points: [value.location]))
                    } else {
                        guard let lastIndex = lines.indices.last else { return }
                        
                        lines[lastIndex].points.append(value.location)
                        
                        if properties.currentTool == .eraser {
    
                            interactedLines = self.linesThatIntersect(with: lines.last!)
                        }
                    }})
                .onEnded({ value in
                    pointsForLine.removeAll()
                    if properties.currentTool == .eraser {
                        lines.removeLast()
                        lines = lines.filter { !interactedLines.contains($0) }
                    } else if properties.currentTool == .lasso {
                        
                        if properties.currentTool == .lasso {
                            lines[lines.count - 1].points.append(value.startLocation)
                        }
                        
                        for line in lines.indices {
                            if lines[lines.count - 1].lassoContainsLine(line: lines[line]) {
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
    
    func midPoint(point1: CGPoint, point2: CGPoint) -> CGPoint {
        //gets the midpoints of the two specified points
        let x=(point1.x+point2.x)/2
        let y=(point1.y+point2.y)/2
        return CGPoint(x: x, y: y)
    }
    
    func smoothCurveFromPoints(_ points: [CGPoint]) -> Path {
        var path = Path()
        let count = points.count
        
        guard count > 1 else {
            // If there are fewer than two points, we can't draw a curve, return an empty path
            return path
        }
        
        path.move(to: points[0])
        
        for i in 0..<count-1 {
            let currentPoint = points[i]
            let nextPoint = points[i + 1]
            
            if i == 0 {
                // The first control point is the first point itself
                path.addLine(to: currentPoint)
            }
            
            let nextNextPoint: CGPoint
            if i + 2 < count {
                nextNextPoint = points[i + 2]
            } else {
                nextNextPoint = nextPoint
            }
            
            // Calculate control points
            let controlPoint1 = CGPoint(x: currentPoint.x + (nextPoint.x - points[max(i-1, 0)].x) / 6.0,
                                        y: currentPoint.y + (nextPoint.y - points[max(i-1, 0)].y) / 6.0)
            
            let controlPoint2 = CGPoint(x: nextPoint.x - (nextNextPoint.x - currentPoint.x) / 6.0,
                                        y: nextPoint.y - (nextNextPoint.y - currentPoint.y) / 6.0)
            
            // Add curve to the next point using the calculated control points
            path.addCurve(to: nextPoint, control1: controlPoint1, control2: controlPoint2)
        }
        
        return path
    }
}

struct Line: Equatable {
    var color: Color
    var width: CGFloat
    var opacity: Double
    var points: [CGPoint] = [CGPoint]()
    
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
}
