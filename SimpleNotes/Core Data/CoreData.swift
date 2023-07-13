//
//  CoreData.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import Foundation
import UIKit
import CoreData

func saveNewTag(properties: CurrentTagProperties, context: NSManagedObjectContext, tag: Tag?) {
  
    let newTag = tag ?? Tag(context: context)
    newTag.symbolName = properties.tagIconName
    newTag.tagName = properties.tagName
    newTag.color = properties.tagColor.toHex()
    newTag.note = nil
    do {
        if context.hasChanges {
            try context.save()
        }
    } catch {
        print("An error occured while saving a tag.")
    }
}

extension Note {
    
    public class func makeFetchRequest() -> NSFetchRequest<Note> {
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        
        let fetchRequest = NSFetchRequest<Note>(entityName: String(describing: Note.self))
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}

extension Tag {
    
    public class func makeFetchRequest() -> NSFetchRequest<Tag> {
        let sortDescriptor = NSSortDescriptor(key: "tagName", ascending: false, selector: #selector(NSString.caseInsensitiveCompare))
        
        let fetchRequest = NSFetchRequest<Tag>(entityName: String(describing: Tag.self))
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}

class PersistenceManager: ObservableObject {
    lazy var persistentContainer: NSPersistentContainer  = {
            let container = NSPersistentContainer(name: "SimpleNotesDataModel")
            container.loadPersistentStores { (persistentStoreDescription, error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
            }
            return container
        }()

    public var context: NSManagedObjectContext {
        
        return self.persistentContainer.viewContext
    }
}
