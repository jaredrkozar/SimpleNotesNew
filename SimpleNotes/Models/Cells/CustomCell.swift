//
//  CustomCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/24/23.
//

import SwiftUI

struct CustomCell<Content: View>: View, SettingsItem {
    let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
    }
}
