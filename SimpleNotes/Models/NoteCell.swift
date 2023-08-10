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
        HStack {
            VStack(alignment: .leading) {
                Text(note.title!)
                Text(note.createdDate ?? Date(), style: .date)
            }
            
            ZStack(alignment: .topTrailing) {
                
                HStack {
                    Image(systemName: "tag")
                        .imageScale(.small)
                    
                    Text("\(note.tag!.count)")
                        .font(.caption)
                        .bold()
                }
                .padding(6)
                .foregroundColor(.white)
                .background(.gray)
                .cornerRadius(12)
            }
        }
    }
}
