//
//  CustomSlider.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 8/6/23.
//

import SwiftUI

struct CustomSlider: View {
    @State private var thumbOffset: CGFloat = 0.0
    var options: [CGFloat]
    @State private var step: CGFloat = 0.0
    @Binding var selected: CGFloat
    @Binding var color: Color
    var deactiveColor: Color = .gray
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                ForEach(0 ..< options.count, id: \.self) { element in
                    
                    let offset = calculateOffset(num: element, totalWidth: geometry.size.width)
                    
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(thumbOffset > offset ? color : deactiveColor)
                        .offset(x: offset)
                 }
                
                Capsule()
                    .foregroundColor(deactiveColor)
                    .frame(width: geometry.size.width, height: 5)
                
                Capsule()
                    .foregroundColor(color)
                    .frame(width:  thumbOffset, height: 5, alignment: .trailing)
                
                Circle()
                    .frame(width: 35, height: 35)
                    .offset(x: thumbOffset)
                    .shadow(radius: 3)
                    .foregroundColor(.white)
                    .gesture(
                    DragGesture()
                        .onChanged { value in
                            
                            changeLineWidth(value: value.location.x, totalWidth: geometry.size.width)
                        }
                        .onEnded { value in
                            if self.step == 0.0, let item = self.options.first {
                                self.selected = item
                                
                                return withAnimation {
                                    self.thumbOffset = 0.0
                                }
                            }
                            
                            let lineWidth = geometry.size.width - 35
                            
                            let percentage = max(0, min(value.location.x / lineWidth, 1.0))
                            let page = round(percentage / self.step)
                            
                            self.selected = self.options[Int(page)]
                            
                            withAnimation {
                                self.thumbOffset = lineWidth * page *
                                self.step
                            }
             
                        }
                    )
            }
            .onAppear {
                
                if options.count > 1 {
                    step = 1.0 / CGFloat(options.count - 1)
                }
                
                let num = calculateOffset(num: options.firstIndex(of: selected)!, totalWidth: geometry.size.width)
                
                changeLineWidth(value: num, totalWidth: geometry.size.width)
            }
        }
    }
    
    func changeLineWidth(value: CGFloat, totalWidth: CGFloat) {
        let lineWidth = totalWidth - 35
        let percentage = max(0, min(value / lineWidth, 1.0))
        
        self.thumbOffset = lineWidth * percentage
    }
    
    func calculateOffset(num: Int, totalWidth: CGFloat) -> CGFloat {
        return CGFloat(num) * self.step * (totalWidth - 15)
    }
}

struct CustomSlider_Previews: PreviewProvider {
    @State static var selected: CGFloat = 4.0
    @State static var color: Color = .green
    
    static var previews: some View {
        CustomSlider(options: [10.0, 20.0, 30.0, 40.0], selected: $selected, color: $color)
    }
}
