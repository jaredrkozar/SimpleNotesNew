//
//  ToggleCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/24/23.
//

import SwiftUI

struct ToggleCell: View, SettingsItem {
    @State var leftText: String
    @Binding var currentValue: Bool
    @Environment(\.tintColor) var tintColor
    
    var body: some View {
        Toggle(leftText, isOn: $currentValue)
            .tint(tintColor)
    }
}
