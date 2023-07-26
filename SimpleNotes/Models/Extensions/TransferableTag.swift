//
//  TransferableTag.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 7/13/23.
//

import SwiftUI

extension Tag: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .tag) {
            ($0.tagName?.data(using: .ascii))!
        }}
  
}
