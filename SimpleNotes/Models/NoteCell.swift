//
//  NoteCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/13/23.
//

import SwiftUI

struct NoteCell: View {
    @ObservedObject var note: Note
    
    var body: some View {
        VStack {
            Text(note.title!)
    
        }
    }
}
