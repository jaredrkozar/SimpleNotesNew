//
//  SortMethods.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/27/23.
//

import SwiftUI

public enum SortOptions: CaseIterable {
    case titleAscending
    case titleDescending
    case dateAscending
    case dateDescending
    
    var title: String {
        switch self {
        case .dateAscending:
            return "Date (Ascending)"
        case .dateDescending:
            return "Date (Descending)"
        case .titleAscending:
            return "Title (Ascending)"
        case .titleDescending:
            return "Title (Descending)"
        
        }
    }
 
    var sortMethods: SortDescriptor<Note> {
        switch self {
        case .titleAscending:
            return SortDescriptor(\.title, order: .forward)
        case .titleDescending:
            return SortDescriptor(\.title, order: .reverse)
        case .dateAscending:
            return SortDescriptor(\.createdDate, order: .forward)
        case .dateDescending:
            return SortDescriptor(\.createdDate, order: .reverse)
        }
    }
}

extension SortOptions: Identifiable {
    public var id: Self { self }
}
