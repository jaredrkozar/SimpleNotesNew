//
//  NoteView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import SwiftUI

struct NoteView: View {
    @StateObject var noteProperties = CurrentNoteProperties()
    @State private var showingToolOptionsMenu = false
    
    var body: some View {
        DrawingView(properties: noteProperties)
            .frame(maxWidth: .infinity)
            .navigationTitle("SwiftUI")

            .toolbar {
                ToolbarItemGroup(placement: .secondaryAction) {
                    ForEach(ToolsList.allCases, id: \.rawValue) { tool in
                        Button(tool.rawValue) {
                            switchToTool(toTool: tool)
                        }
                    
                    }
                }
            }
            .sheet(isPresented: $showingToolOptionsMenu) {
                ToolOptionsMenu(properties: noteProperties)
                    .presentationDetents(noteProperties.currentTool != .eraser ? [.medium] : [.custom(MyDetent.self)])
                    .presentationDragIndicator(.automatic)
            }
    }
    
    func switchToTool(toTool: ToolsList?) {
        noteProperties.showSelectionMenu = false
        if noteProperties.currentTool == toTool {
            showingToolOptionsMenu = true
        } else {
            noteProperties.currentTool = toTool!
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView()
    }
}

struct MyDetent: CustomPresentationDetent {
    // 1
    static func height(in context: Context) -> CGFloat? {
        // 2
        return max(50, context.maxDetentValue * 0.2)
    }
}

