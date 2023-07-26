//
//  SettingsView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 6/28/23.
//

import SwiftUI

struct SettingsView: View {
    @State var color: Color = .red
    @State var present: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Dismiss", action: {
                    present = false
                }).padding()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

