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
    func saveExistingTag(properties: CurrentTagProperties) {
      
        self.symbolName = properties.tagIconName
        self.tagName = properties.tagName
        self.color = properties.tagColor.toHex()
        self.note = nil
        do {
            if CoreDataManager().context.hasChanges {
                try CoreDataManager().context.save()
            }
        } catch {
            print("An error occured while saving a tag.")
        }
    }
    
    func deleteTag() {
      
        CoreDataManager().context.delete(self)
        do {
            if CoreDataManager().context.hasChanges {
                try CoreDataManager().context.save()
            }
        } catch {
            print("An error occured while saving a tag.")
        }
    }
}
