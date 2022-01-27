//
//  Note+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/24/22.
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
    @NSManaged public var tags: Set<Tags>?

}

// MARK: Generated accessors for tags
extension Note {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tags)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tags)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: Set<Tags>)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension Note : Identifiable {

}
