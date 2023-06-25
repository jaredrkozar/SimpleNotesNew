//
//  LinkCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import Foundation
import SwiftUI

struct LinkCell<Destination: View>: View, SettingsItem {
    var title: String
    var destination: Destination

    public var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(title)
            }
        }
    }
}
