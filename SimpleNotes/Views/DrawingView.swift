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
    @State private var pointsForLine = [CGPoint]()
    @State private var previousPoint: CGPoint = CGPoint()
    @State private var previousPreviousPoint: CGPoint = CGPoint()
    
    var body: some View {
        Canvas { context, size in
            for line in lines {
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
                        lines.append(Line(color: .blue, width: 4.0, opacity: 1.0, path: Path()))
                        //sets up previouspoint and previousPreviousPoint to be the first item in the points array (the current point)
                        previousPoint = pointsForLine[pointsForLine.count - 1]
                        previousPoint = pointsForLine[pointsForLine.count - 1]
                    } else {
                        previousPreviousPoint = previousPoint
                        previousPoint = pointsForLine[pointsForLine.count - 2]
                        
                        //gets the midpoint of the previous point and the point before that one
                        let firstMidpoint: CGPoint = midPoint(point1: previousPoint, point2: previousPreviousPoint)
                        
                        //gets the midpoint of the current point and the previous point
                        let secondMidpoint: CGPoint = midPoint(point1: value.location, point2: previousPoint)
                        
                        //moves to first midpoint and adds quadratic curve between the second midpoint and the previous point
                        lines[index].path.move(to: firstMidpoint)
                        lines[index].path.addQuadCurve(to: secondMidpoint, control: previousPoint)
                    }})
                .onEnded({ value in
                    
                    pointsForLine.removeAll()
                })
        )
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
}
