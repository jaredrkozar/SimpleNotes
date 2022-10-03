//
//  TagsForNote+CoreDataProperties.swift
//  SimpleNotes
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
    @NSManaged public var note: Note?

}

extension TagsForNote : Identifiable {

}
