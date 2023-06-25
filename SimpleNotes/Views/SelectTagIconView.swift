//
//  SelectTagIconView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/21/23.
//

import Foundation
import SwiftUI

struct SelectTagIconView: View {
    
    @Binding var selectedIconName: String
    @State var iconColor: Color
    @State private var searchText = ""
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 75), alignment: .top)]) {
                
                ForEach(allSymbols) { symbolSection in
                    let filteredSymbols = symbolSection.symbols.filter({symbol in searchText.isEmpty ? true : symbol.lowercased().contains(searchText)})
                    
                    Section(header: Text(symbolSection.sectionName).font(.title)) {
                        ForEach(filteredSymbols, id: \.self) { symbolItem in
                            
                            Button {
                                selectedIconName = symbolItem
                            } label: {
                                Image(systemName: symbolItem)
                                    .font(.system(size: 45, weight: .medium))
                                    .padding(20)
                                    .background(symbolItem == selectedIconName ? iconColor.opacity(0.5) : .clear)
                                    .border(symbolItem == selectedIconName ? iconColor : .clear, width: 5)
                                    .cornerRadius(12.0)
                            }
                            
                        }
                 }
                }
            }
        }
        .searchable(text: $searchText)
    }
}

class SymbolCell: UICollectionViewCell {
    var imageView: UIImageView {
        let image = UIImageView(frame: .zero)
        image.tintColor = .label
        return image
    }
    
    override func layoutIfNeeded() {
        imageView.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        self.addSubview(imageView)
    }
}
