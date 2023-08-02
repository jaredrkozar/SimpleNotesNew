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
                context.stroke(line.path, with: .color(line.color), style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    let index = lines.count - 1

                    self.pointsForLine.append(value.location)
                    
                    if value.translation.width + value.translation.height == 0 {
                        //length of line is zero -> new line
                        lines.append(Line(color: properties.toolProperties.color, width: properties.toolProperties.width, opacity: properties.currentTool != .highlighter ? 1.0 : 0.6, path: Path()))
                        print(":FFFFFF")
                        
                        //sets up previouspoint and previousPreviousPoint to be the first item in the points array (the current point)
                        previousPoint = pointsForLine[pointsForLine.count - 1]
                    } else {
                        guard index > -1  else { print(index)
                            return }
                        previousPreviousPoint = previousPoint
                        previousPoint = pointsForLine[pointsForLine.count - 2]
                        
                        //gets the midpoint of the previous point and the point before that one
                        let firstMidpoint: CGPoint = midPoint(point1: previousPoint, point2: previousPreviousPoint)
                        
                        //gets the midpoint of the current point and the previous point
                        let secondMidpoint: CGPoint = midPoint(point1: value.location, point2: previousPoint)
                        
                        //moves to first midpoint and adds quadratic curve between the second midpoint and the previous point
                        lines[index].path.move(to: firstMidpoint)
                        lines[index].path.addQuadCurve(to: secondMidpoint, control: previousPoint)
                        lines[index].points.append(value.location)
                        
                        if properties.currentTool == .eraser {
    
                            interactedLines = self.linesThatIntersect(with: lines.last!)
                         
                            
  
                        }
                    }})
                .onEnded({ value in
                    
                    pointsForLine.removeAll()
                    if properties.currentTool == .eraser {
                        lines.removeLast()
                        lines = lines.filter { !interactedLines.contains($0) }
                        
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
}

struct Line: Equatable {
    var color: Color
    var width: CGFloat
    var opacity: Double
    var path: Path
    var points: [CGPoint] = [CGPoint]()
    
    mutating func updateOpacity() {
        self.opacity = 0.6
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
