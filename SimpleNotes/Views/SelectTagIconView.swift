//
//  SelectTagIconView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/21/23.
//

import Foundation
import SwiftUI

struct SelectTagIconView: View {
    
    @ObservedObject var properties: CurrentTagProperties
    @State private var searchText = ""
    @State private var currentSymbol = "mic"
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 75), alignment: .top)]) {
                
                ForEach(allSymbols) { symbolSection in
                    let filteredSymbols = symbolSection.symbols.filter({symbol in searchText.isEmpty ? true : symbol.lowercased().contains(searchText.lowercased())})
                    
                    Section(header: Text(symbolSection.sectionName).font(.title)) {
                        ForEach(filteredSymbols, id: \.self) { symbolItem in
                            SymbolCell(properties: properties, currentSymbol: symbolItem)
                    }
                 }
                }
            }
        }
        .accentColor(properties.tagColor)
        .searchable(text: $searchText)
    }
}

struct SymbolCell: View {
    @ObservedObject var properties: CurrentTagProperties
    @State var currentSymbol: String
 
    var body: some View {
        Button {
            properties.tagIconName = currentSymbol
        } label: {
            Image(systemName: currentSymbol)
                .font(.system(size: 45, weight: .medium))
                .padding(15)
        }
        .cornerRadius(15.0)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(properties.tagColor, lineWidth: properties.tagIconName == currentSymbol ? 4.0 : 0.0)
                .background(properties.tagIconName == currentSymbol ? properties.tagColor.opacity(0.25) : .clear)
        )
    }
}


