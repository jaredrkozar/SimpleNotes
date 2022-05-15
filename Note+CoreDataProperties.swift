//
//  Note+CoreDataProperties.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/15/22.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: Date?
    @NSManaged public var noteID: String?
    @NSManaged public var title: String?
    @NSManaged public var isLocked: Bool
    @NSManaged public var tags: NSSet?
    @NSManaged public var textbox: NSSet?

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
    @NSManaged public func removeFromTags(_ values: Set<Tags>)

}

// MARK: Generated accessors for textbox
extension Note {

    @objc(addTextboxObject:)
    @NSManaged public func addToTextbox(_ value: TextBox)

    @objc(removeTextboxObject:)
    @NSManaged public func removeFromTextbox(_ value: TextBox)

    @objc(addTextbox:)
    @NSManaged public func addToTextbox(_ values: Set<TextBox>)

    @objc(removeTextbox:)
    @NSManaged public func removeFromTextbox(_ values: Set<TextBox>)

}

extension Note : Identifiable {

}
