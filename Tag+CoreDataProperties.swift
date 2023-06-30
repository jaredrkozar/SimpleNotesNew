//
//  Tag+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 6/25/23.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var color: String?
    @NSManaged public var symbolName: String?
    @NSManaged public var tagName: String?
    @NSManaged public var note: Note?

}

extension Tag : Identifiable {
    
    func deleteTag(context: NSManagedObjectContext) {
      
        context.delete(self)
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("An error occured while saving a tag.")
        }
    }
}
