//
//  TextCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct TextCell: View, SettingsItem {

    @Binding var currentValue: String
    @State var placeholder: String
    @State var leftText: String
    
    var body: some View {
        HStack {
            Text(leftText)
            
            TextField(placeholder, text: $currentValue)
                .multilineTextAlignment(.trailing)
        }
    }
}
