//
//  NoteView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct NoteView: View {
    var body: some View {
        DrawingView()
            .frame(maxWidth: .infinity)
        
            .navigationTitle("SwiftUI")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Pen") {
                        print("Pressed")
                    }

                    Spacer()

                    Button("Highlighter") {
                        print("Pressed")
                    }
                    Button("Eraser") {
                        print("Pressed")
                    }
                }
            }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView()
    }
}
