//
//  SettingsModels.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import Foundation
import SwiftUI

struct SettingsPage<SettingsSectionView: View>: View {
    let content: () -> SettingsSectionView
    
    init(@ViewBuilder _ content: @escaping () -> SettingsSectionView) {
        self.content = content
    }

    var body: some View {
        List {
            content()
        }
    }
}

struct SettingsSectionView<SettingsItem: View>: View {
    let content: SettingsItem
    var header: String?
    var footer: String?
    
    init(footer: String? = nil, header: String? = nil, @ViewBuilder _ content: () -> SettingsItem) {
        self.content = content()
        self.header = header
        self.footer = footer
    }

    var body: some View {
        Section {
           content
       } header: {
           header != nil ? Text(header!) : nil
       } footer: {
           footer != nil ? Text(footer!) : nil
       }
    }
}

protocol SettingsItem {
}

struct CustomTintColor: EnvironmentKey {
    static var defaultValue: Color = .clear
    
    typealias Value = Color
}

extension EnvironmentValues {
    var tintColor: Color {
        get {
            self[CustomTintColor.self]
        } set {
            self[CustomTintColor.self] = newValue
        }
    }
}
