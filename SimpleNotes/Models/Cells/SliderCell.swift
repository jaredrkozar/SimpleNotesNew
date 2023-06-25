//
//  SliderCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/23/23.
//

import SwiftUI

struct SliderCell: View, SettingsItem {
    @State var range: ClosedRange<Double>
    @State var step: Double
    @Binding var currentValue: Double
    
    var body: some View {
        HStack {
            Slider(
                        value: $currentValue,
                        in: range,
                        step:  step,
                        onEditingChanged: { _ in }
                    ) {
                        Text("\(currentValue)")
                    }
        }
    }
}
