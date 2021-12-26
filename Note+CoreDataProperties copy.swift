//
//  Note+CoreDataProperties.swift
//  
//
//  Created by JaredKozar on 12/26/21.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: Date?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var tagsForNote: NSSet?

}

// MARK: Generated accessors for tagsForNote
extension Note {

    @objc(addTagsForNoteObject:)
    @NSManaged public func addToTagsForNote(_ value: TagsForNote)

    @objc(removeTagsForNoteObject:)
    @NSManaged public func removeFromTagsForNote(_ value: TagsForNote)

    @objc(addTagsForNote:)
    @NSManaged public func addToTagsForNote(_ values: NSSet)

    @objc(removeTagsForNote:)
    @NSManaged public func removeFromTagsForNote(_ values: NSSet)

}
