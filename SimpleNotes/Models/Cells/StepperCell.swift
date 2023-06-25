//
//  StepperCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/23/23.
//

import SwiftUI

struct StepperCell<T: Strideable & Comparable>: View, SettingsItem {
    var icon: RoundedIcon? = nil
    @State var range: ClosedRange<T>
    @State var step: T.Stride
    @State var text: String
    @Binding var currentValue: T
    
    var body: some View {
        HStack {
            Stepper("\(text): \(String(describing: currentValue))", value: $currentValue, in: range, step: step)
        }
    }
}
