//
//  DrawingView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/29/23.
//

import Foundation
import SwiftUI

struct DrawingView: View {
    @ObservedObject var properties: CurrentNoteProperties
    @State private var currentPoint: CGPoint? = .zero
    @State private var showChangeLineProprtiesMenu: Bool = false
    
    @State var selectMinX: CGFloat?
    @State var selectMaxX: CGFloat?
    @State var selectMinY: CGFloat?
    
    var body: some View {
        ZStack {
            if properties.canshowSelectMenu == true && properties.draggingLasso == false {
                lassoMenu
                    .position(properties.selectMenuPoint!)
                    .allowsHitTesting(true)
            }
            
            ZStack {
                Color("clearColor")
                ForEach(properties.lines, id: \.id){ line in
                    line
                        .stroke(line.color, style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round))
                   }
               }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    let lineCount = properties.lines.count - 1
                    if properties.currentTool != .scoll && properties.selectMenuRect?.contains(value.startLocation) == false
                    {
                        if value.translation == .zero {
                            //length of line is zero -> new line
                            
                            if properties.selectedLines.count >= 1 && properties.lines[lineCount].containsPoint(test: value.startLocation) {
                                
                                properties.draggingLasso = true
                            } else {
                                print("DLDLDdd")
                                properties.endLasso()
                                properties.lines.append(Line(color: properties.toolProperties.color, width: properties.toolProperties.width, opacity: properties.currentTool != .highlighter ? 1.0 : 0.6, points: [value.location]))
                            }
                        } else {
                            //the user is currently moving their finger
                            
                            guard value.translation != .zero else {
                                properties.lines.removeLast()
                                print("REMOVE")
                                return
                            }
                            
                            if properties.selectedLines.count > 1 && properties.draggingLasso == true {
       
                                //moving the currently selected lines
                                var differenceX: CGFloat = 0
                                var differenceY: CGFloat = 0
                                
                                if (currentPoint == CGPoint.zero && value.location != CGPoint.zero){
                                    differenceX = value.location.x
                                        differenceY = value.location.y
                                    } else{
                                        differenceX = value.location.x - currentPoint!.x
                                        differenceY = value.location.y - currentPoint!.y
                                    }
                                let vector = CGVector(dx: differenceX, dy: differenceY)
                                
                                for (index, _) in properties.selectedLines.enumerated() {
                                    
                                    properties.lines[index].translate(vector: vector)
                                }
                                properties.selectMenuPoint = CGPoint(x: properties.selectMenuPoint!.x + differenceX, y: properties.selectMenuPoint!.y + differenceY)
                                
                                currentPoint = value.location
                                
                            } else {
                                guard let lastIndex = properties.lines.indices.last else { return }
                                
                                properties.lines[lastIndex].points.append(value.location)
                                
                                if properties.currentTool == .eraser {
                                    
                                    for (index, _) in properties.lines.enumerated() {
                                    
                                        if
                                            properties.lines[properties.lines.count - 1].intersects(line: properties.lines[index]) && index != properties.lines.count - 1 {
                                            properties.selectedLines.append(index)
                                            properties.lines[index].opacity = 0.5
                                        }
                                    }
                                    
                                } else if properties.currentTool == .lasso {
                                    updateSelectRect(value.location)
                                }
                            }
                        }
                        
                    }})
                .onEnded({ value in
                    guard value.translation != .zero else {
                        properties.lines.removeLast()
                        return
                    }
                    
                    if properties.currentTool == .eraser {
                        properties.lines.removeLast()
                        removeAllInteractedLines()
                    } else if properties.currentTool == .lasso {
                        if properties.selectedLines.count == 0 {
                            properties.lines[properties.lines.count - 1].points.append(value.startLocation)
                            
                            for (index, _) in properties.lines.enumerated() {
                                if properties.lines[properties.lines.count - 1].lassoContainsLine(line: properties.lines[index]) && index != properties.lines.count - 1 {
                                    properties.selectedLines.append(index)
                                }
                            }
                            
                            properties.selectMenuPoint = CGPoint(x: (selectMinX! + selectMaxX!) / 2, y: (selectMinY! - 30.0))
                        }
                        endSelectRect()
                        print(properties.selectedLines.count)
                    }
                    
                })
        )
        .sheet(isPresented: $showChangeLineProprtiesMenu) {
            ChangeStrokesView(properties: properties, newSelectedColor: .blue)
                .presentationDetents([.large])
                .presentationDragIndicator(.automatic)
        }
    }
    
    var lassoMenu: some View {
        HStack {
            Button {
                properties.lines.removeLast()
                removeAllInteractedLines()
                properties.endLasso()
            } label: {
                Image(systemName: "trash")
                    .imageScale(.medium)
            }
            
            Button {
                showChangeLineProprtiesMenu = true
            } label: {
                Image(systemName: "pin")
                    .imageScale(.medium)
            }
        }
        .padding(5)
        .zIndex(2.0)
        .background(.green)
        .foregroundColor(.white)
        .cornerRadius(6.0)
        .frame(width: 50)
        .allowsHitTesting(true)
    }
    
    var lassoMenuBG: some View {
        Rectangle()
        .padding(5)
        .zIndex(2.0)
        .background(.brown)
        .foregroundColor(.white)
        .cornerRadius(6.0)
        .frame(width: 50)
        .allowsHitTesting(true)
    }
    
    func removeAllInteractedLines() {
        properties.lines = properties.lines.enumerated().filter { index, stroke in
            !properties.selectedLines.contains(index)
        }.map { _, stroke in
            return stroke
        }
        properties.selectedLines.removeAll()
        properties.selectMenuPoint = nil
    }
    
    private func updateSelectRect(_ translatedPoint: CGPoint) {
        
        guard translatedPoint.y != 0.0 else { return }
        guard let updatedMinX = selectMinX,
              let updateMaxX = selectMaxX,
              let updateMinY = selectMinY else {
            selectMinX = translatedPoint.x
            selectMaxX = translatedPoint.x
            selectMinY = translatedPoint.y
            return
        }
        
        selectMinX = min(updatedMinX, translatedPoint.x)
        selectMaxX = max(updateMaxX, translatedPoint.x)
        selectMinY = min(updateMinY, translatedPoint.y)
    }
    
    private func endSelectRect() {
        
        selectMinX = nil
        selectMaxX = nil
        selectMinY = nil
    }
}

struct Line: Equatable, Shape {
    func path(in rect: CGRect) -> Path {
        return path
    }
    
    var color: Color
    var width: CGFloat
    var opacity: Double
    var points: [CGPoint] = [CGPoint]()
    let id = UUID()
    
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
        
        for i in 0 ..< count - 1 {
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
    
    mutating func removeAllPoints() {
        self.points.removeAll()
    }
    
}

public extension CGPoint{
    
    // Moves the CGPoint by the specified value
    func moveBy(x: CGFloat, y: CGFloat) -> CGPoint {
        return self + CGVector(dx: x, dy: y)
    }
    
    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
}

struct ChangeStrokesView: View {
    
    @ObservedObject var properties: CurrentNoteProperties
    @State var newSelectedColor: Color = .green
    @State var newSelectedWidth: CGFloat = 2.5
    
    var body: some View {
        
        Text("{DLDLDD}")
    }
}
