//
//  Note+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var modifiedDate: Date?
    @NSManaged public var data: Data?
    @NSManaged public var isLocked: Bool
    @NSManaged public var noteID: UUID?
    @NSManaged public var tag: NSSet?

}

// MARK: Generated accessors for tag
extension Note {

    @objc(addTagObject:)
    @NSManaged public func addToTag(_ value: Tag)

    @objc(removeTagObject:)
    @NSManaged public func removeFromTag(_ value: Tag)

    @objc(addTag:)
    @NSManaged public func addToTag(_ values: NSSet)

    @objc(removeTag:)
    @NSManaged public func removeFromTag(_ values: NSSet)

}

extension Note : Identifiable {
 
}
