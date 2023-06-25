//
//  OptionPickerCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/22/23.
//

import SwiftUI

struct OptionPickerCell<T: Hashable>: View, SettingsItem {
    
    @State var leftText: String
    @State var options: [T]
    @Binding var currentValue: T
    
    var body: some View {
        HStack {
            Picker(leftText, selection: $currentValue) {
                ForEach(options, id: \.self) {
                    Text(String(describing: $0))
                }
            }
        }
    }
}
