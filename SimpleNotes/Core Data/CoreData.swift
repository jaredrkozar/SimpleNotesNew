//
//  CoreData.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/20/23.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: ObservableObject {
    private static var persistentContainer: NSPersistentContainer = {
        
        return NSPersistentContainer(name: "SimpleNotesDataModel")
    }()

    public var context: NSManagedObjectContext {
        
        get {
            return CoreDataManager.persistentContainer.viewContext
        }
    }

    init() {
        CoreDataManager.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

func saveNewTag(name: String, symbol: String, color: Int) {
  
    let newTag = Tag(context: CoreDataManager().context)
    newTag.symbolName = symbol
    newTag.tagName = name
    newTag.color = 2
    newTag.note = nil
    do {
        if CoreDataManager().context.hasChanges {
            try CoreDataManager().context.save()
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
        let sortDescriptor = NSSortDescriptor(key: "tagName", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        
        let fetchRequest = NSFetchRequest<Tag>(entityName: String(describing: Tag.self))
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}

