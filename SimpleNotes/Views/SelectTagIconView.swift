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
        .searchable(text: $searchText)
    }
}

struct SymbolCell: View {
    @ObservedObject var properties: CurrentTagProperties
    @State var currentSymbol: String
    
    var body: some View {
        Button {
            properties.iconName = currentSymbol
        } label: {
            Image(systemName: currentSymbol)
                .font(.system(size: 45, weight: .medium))
                .padding(15)
        }
        .cornerRadius(0.2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(properties.color.color, lineWidth: properties.iconName == currentSymbol ? 4.0 : 0.0)
                .background(properties.iconName == currentSymbol ? properties.color.color.opacity(0.25) : .clear)
        )
    }
}


