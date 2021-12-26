//
//  TagsForNote+CoreDataProperties.swift
//  
//
//  Created by JaredKozar on 12/26/21.
//
//

import Foundation
import CoreData


extension TagsForNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagsForNote> {
        return NSFetchRequest<TagsForNote>(entityName: "TagsForNote")
    }

    @NSManaged public var tags: String?
    @NSManaged public var note: NSSet?

}

// MARK: Generated accessors for note
extension TagsForNote {

    @objc(addNoteObject:)
    @NSManaged public func addToNote(_ value: Note)

    @objc(removeNoteObject:)
    @NSManaged public func removeFromNote(_ value: Note)

    @objc(addNote:)
    @NSManaged public func addToNote(_ values: NSSet)

    @objc(removeNote:)
    @NSManaged public func removeFromNote(_ values: NSSet)

}
