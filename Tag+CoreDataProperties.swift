//
//  Tag+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 6/11/23.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var color: Int16
    @NSManaged public var symbolName: String?
    @NSManaged public var tagName: String?
    @NSManaged public var note: Note?

}

extension Tag : Identifiable {

}
